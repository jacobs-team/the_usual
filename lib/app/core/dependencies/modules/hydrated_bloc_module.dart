// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

/// {@template hydrated_bloc_module}
/// An [injectable] module responsible for initializing the [HydratedStorage]
/// used by Bloc.
///
/// This module ensures that the storage directory is correctly configured
/// for both web and native platforms before the app starts.
/// {@endtemplate}
@module
abstract class HydratedBlocModule {
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
    );
  }
}
