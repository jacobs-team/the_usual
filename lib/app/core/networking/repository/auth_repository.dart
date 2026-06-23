import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/environment.dart';

/// The outcome of an interactive Google sign-in: the signed-in [user] and
/// whether this is the first time the Google identity has authenticated into
/// this Firebase project ([isNewUser]).
typedef SignInResult = ({AuthUser user, bool isNewUser});

/// {@template auth_repository}
/// The single touchpoint for authentication. Signs in with Google and exchanges
/// the credential with Firebase Auth, exposing the current user as a stream and
/// mapping Firebase/Google accounts to [AuthUser] so callers never depend on
/// the SDK types.
/// {@endtemplate}
abstract interface class AuthRepository {
  /// Emits the current user, or null when signed out. Broadcast. Driven by
  /// Firebase Auth, so it emits a persisted session on startup.
  Stream<AuthUser?> get authChanges;

  /// Idempotent; completes once the Google sign-in SDK is initialized.
  Future<void> initialize();

  /// Interactive sign-in. Returns the signed-in user and whether the account is
  /// new to this project, or null when the user cancels.
  Future<SignInResult?> signIn();

  /// Signs out of both Firebase and Google.
  Future<void> signOut();
}

/// {@macro auth_repository}
@LazySingleton(as: AuthRepository)
class GoogleAuthRepository implements AuthRepository {
  /// {@macro auth_repository}
  GoogleAuthRepository([
    @ignoreParam GoogleSignIn? googleSignIn,
    @ignoreParam FirebaseAuth? firebaseAuth,
  ]) : _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
       _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;
  bool _initialized = false;

  @override
  Stream<AuthUser?> get authChanges => _firebaseAuth.authStateChanges().map(
    (user) => user == null ? null : _toAuthUser(user),
  );

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    await _googleSignIn.initialize(
      clientId: EnvironmentConfig.googleIosClientId,
      serverClientId: EnvironmentConfig.googleServerClientId,
    );
  }

  @override
  Future<SignInResult?> signIn() async {
    if (!_googleSignIn.supportsAuthenticate()) return null;
    final GoogleSignInAccount account;
    try {
      account = await _googleSignIn.authenticate();
    } on GoogleSignInException catch (error) {
      // A user-cancelled sign-in is not an error; anything else propagates.
      if (error.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }

    final credential = GoogleAuthProvider.credential(
      idToken: account.authentication.idToken,
    );
    final result = await _firebaseAuth.signInWithCredential(credential);
    final user = result.user!;
    return (
      user: _toAuthUser(user),
      isNewUser: result.additionalUserInfo?.isNewUser ?? false,
    );
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  AuthUser _toAuthUser(User user) => AuthUser(
    id: user.uid,
    email: user.email ?? '',
    displayName: user.displayName,
    photoUrl: user.photoURL,
  );
}
