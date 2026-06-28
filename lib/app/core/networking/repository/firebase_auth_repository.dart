import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:the_usual/app/app.dart';

/// {@template firebase_auth_repository}
/// Wraps Firebase Auth. It is the only place that talks to the SDK, exchanging
/// Google credentials for a Firebase session and mapping Firebase's `User`/
/// `UserCredential` down to the app's [AuthUser]/[SignInResult] so callers never
/// depend on the SDK types.
/// {@endtemplate}
@singleton
class FirebaseAuthRepository {
  /// {@macro firebase_auth_repository}
  FirebaseAuthRepository([@ignoreParam FirebaseAuth? firebaseAuth])
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  /// Emits the current user, or null when signed out. Broadcast, and emits a
  /// persisted session on startup.
  Stream<AuthUser?> get authChanges => _firebaseAuth.authStateChanges().map(
    (user) => user == null ? null : _toAuthUser(user),
  );

  /// Exchanges a Google [idToken] for a Firebase session.
  Future<SignInResult> signInWithGoogleIdToken(String idToken) async {
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    final result = await _firebaseAuth.signInWithCredential(credential);
    return _toSignInResult(result);
  }

  /// Signs in with Google through Firebase's hosted popup, used on web where
  /// the `google_sign_in` SDK can't run an app-driven flow. Returns null when
  /// the user closes or supersedes the popup.
  Future<SignInResult?> signInWithGooglePopup() async {
    try {
      final result = await _firebaseAuth.signInWithPopup(GoogleAuthProvider());
      return _toSignInResult(result);
    } on FirebaseAuthException catch (error) {
      // A closed or superseded popup is a cancellation, not a failure.
      const cancelCodes = {
        'popup-closed-by-user',
        'cancelled-popup-request',
        'web-context-canceled',
      };
      if (cancelCodes.contains(error.code)) return null;
      rethrow;
    }
  }

  /// Signs out of the Firebase session.
  Future<void> signOut() => _firebaseAuth.signOut();

  SignInResult _toSignInResult(UserCredential credential) => (
    user: _toAuthUser(credential.user!),
    isNewUser: credential.additionalUserInfo?.isNewUser ?? false,
  );

  AuthUser _toAuthUser(User user) => AuthUser(
    id: user.uid,
    email: user.email ?? '',
    displayName: user.displayName,
    photoUrl: user.photoURL,
  );
}
