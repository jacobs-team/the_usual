// coverage:ignore-file

import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

/// {@template hydrated_bloc_module}
/// An [injectable] module responsible for initializing the [HydratedStorage]
/// used by Bloc.
///
/// This module ensures that the storage directory is correctly configured
/// for both web and native platforms before the app starts. On native
/// platforms the storage is encrypted at rest with an AES key held in the
/// platform keychain/keystore.
/// {@endtemplate}
@module
abstract class HydratedBlocModule {
  static const _encryptionKeyName = 'hydrated_storage_key';

  /// Initializes the [HydratedStorage] and registers it as a dependency.
  ///
  /// This method is marked with [@preResolve] to ensure that the storage
  /// is fully built and assigned to [HydratedBloc.storage] before the
  /// dependency injection container finishes its setup.
  @preResolve
  Future<HydratedStorage> init() async {
    return HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorageDirectory.web
          : HydratedStorageDirectory(
              (await getApplicationDocumentsDirectory()).path,
            ),
      // Secure storage is keychain/keystore backed on native platforms only;
      // web storage remains unencrypted.
      encryptionCipher: kIsWeb ? null : HydratedAesCipher(await _aesKey()),
    );
  }

  /// Returns the persisted AES key, generating and storing one on first run.
  Future<List<int>> _aesKey() async {
    const secureStorage = FlutterSecureStorage();
    final stored = await secureStorage.read(key: _encryptionKeyName);
    if (stored != null) return base64Url.decode(stored);

    final random = Random.secure();
    final key = List<int>.generate(32, (_) => random.nextInt(256));
    await secureStorage.write(
      key: _encryptionKeyName,
      value: base64UrlEncode(key),
    );
    return key;
  }
}
