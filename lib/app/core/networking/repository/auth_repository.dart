import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:the_usual/app/app.dart';

/// The outcome of an interactive Google sign-in: the signed-in `user` and
/// whether this is the first time the Google identity has authenticated into
/// this Firebase project (`isNewUser`).
typedef SignInResult = ({AuthUser user, bool isNewUser});

/// {@template auth_repository}
/// The single touchpoint for authentication. It orchestrates the two SDK
/// wrappers: it gets a Google ID token from [GoogleSignInRepository] and trades
/// it for a Firebase session via [FirebaseAuthRepository], exposing the current
/// user as a stream of [AuthUser] so callers never depend on the SDK types. On
/// web, where the Google SDK can't run an app-driven flow, it defers to
/// Firebase's hosted Google popup instead.
/// {@endtemplate}
@lazySingleton
class AuthRepository {
  /// {@macro auth_repository}
  AuthRepository(this._googleSignInRepository, this._firebaseAuthRepository);

  final GoogleSignInRepository _googleSignInRepository;
  final FirebaseAuthRepository _firebaseAuthRepository;

  /// Emits the current user, or null when signed out. Broadcast. Driven by
  /// Firebase Auth, so it emits a persisted session on startup.
  Stream<AuthUser?> get authChanges => _firebaseAuthRepository.authChanges;

  /// Idempotent; completes once sign-in is ready to use.
  Future<void> initialize() => _googleSignInRepository.initialize();

  /// Interactive sign-in. Returns the signed-in user and whether the account is
  /// new to this project, or null when the user cancels.
  Future<SignInResult?> signIn() async {
    if (kIsWeb) return _firebaseAuthRepository.signInWithGooglePopup();
    final idToken = await _googleSignInRepository.authenticate();
    if (idToken == null) return null;
    return _firebaseAuthRepository.signInWithGoogleIdToken(idToken);
  }

  /// Signs out of both Firebase and Google.
  Future<void> signOut() async {
    await _firebaseAuthRepository.signOut();
    await _googleSignInRepository.signOut();
  }
}
