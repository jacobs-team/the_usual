import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:the_usual/environment.dart';

/// {@template google_sign_in_repository}
/// Wraps the `google_sign_in` SDK and the platform differences around it. It is
/// the only place that talks to the SDK, exposing just the Google ID token the
/// rest of auth needs and no SDK types. On web the SDK is unused (Firebase's
/// own Google popup handles sign-in), so its methods no-op there.
/// {@endtemplate}
@singleton
class GoogleSignInRepository {
  /// {@macro google_sign_in_repository}
  GoogleSignInRepository([@ignoreParam GoogleSignIn? googleSignIn])
    : _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final GoogleSignIn _googleSignIn;
  bool _initialized = false;

  /// Initializes the SDK once with the app's OAuth client ids. Idempotent.
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    if (kIsWeb) return;
    await _googleSignIn.initialize(
      clientId: EnvironmentConfig.googleIosClientId,
      serverClientId: EnvironmentConfig.googleServerClientId,
    );
  }

  /// Runs the interactive Google sign-in and returns the account's ID token, or
  /// null when the user cancels or the platform can't run an app-driven flow
  /// (e.g. web, where Firebase's popup is used instead).
  Future<String?> authenticate() async {
    if (kIsWeb || !_googleSignIn.supportsAuthenticate()) return null;
    final GoogleSignInAccount account;
    try {
      account = await _googleSignIn.authenticate();
    } on GoogleSignInException catch (error) {
      // A user-cancelled sign-in is not an error; anything else propagates.
      if (error.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
    return account.authentication.idToken;
  }

  /// Signs out of the Google SDK. A no-op on web, where it isn't initialized.
  Future<void> signOut() async {
    if (kIsWeb) return;
    await _googleSignIn.signOut();
  }
}
