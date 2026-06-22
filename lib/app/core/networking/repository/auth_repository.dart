import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/environment.dart';

/// {@template auth_repository}
/// The single touchpoint for the google_sign_in SDK. Exposes the current Google
/// user as a stream and the actions to change it, mapping SDK accounts to
/// [AuthUser] so callers never depend on google_sign_in types.
/// {@endtemplate}
abstract interface class AuthRepository {
  /// Emits the current user, or null when signed out. Broadcast.
  Stream<AuthUser?> get authChanges;

  /// Idempotent; completes once the SDK is initialized.
  Future<void> initialize();

  /// Interactive sign-in. The resulting user arrives on [authChanges]. Returns
  /// normally on user cancellation; throws on real failure.
  Future<void> signIn();

  /// Silent re-auth on startup.
  Future<void> restore();

  /// Signs out (keeps the account for future lightweight auth).
  Future<void> signOut();
}

/// {@macro auth_repository}
@LazySingleton(as: AuthRepository)
class GoogleAuthRepository implements AuthRepository {
  /// {@macro auth_repository}
  GoogleAuthRepository([@ignoreParam GoogleSignIn? googleSignIn])
    : _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final GoogleSignIn _googleSignIn;
  final StreamController<AuthUser?> _authChanges =
      StreamController<AuthUser?>.broadcast();
  bool _initialized = false;

  @override
  Stream<AuthUser?> get authChanges => _authChanges.stream;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    await _googleSignIn.initialize(
      clientId: EnvironmentConfig.googleIosClientId,
      serverClientId: EnvironmentConfig.googleServerClientId,
    );
    // The repository is an app-lifetime singleton, so the subscription lives
    // as long as the app and is not stored for cancellation.
    _googleSignIn.authenticationEvents.listen(
      _onAuthenticationEvent,
      onError: (Object _) => _authChanges.add(null),
    );
  }

  void _onAuthenticationEvent(GoogleSignInAuthenticationEvent event) {
    final account = switch (event) {
      GoogleSignInAuthenticationEventSignIn() => event.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };
    _authChanges.add(account == null ? null : _toAuthUser(account));
  }

  AuthUser _toAuthUser(GoogleSignInAccount account) => AuthUser(
    id: account.id,
    email: account.email,
    displayName: account.displayName,
    photoUrl: account.photoUrl,
  );

  @override
  Future<void> signIn() async {
    if (!_googleSignIn.supportsAuthenticate()) return;
    try {
      await _googleSignIn.authenticate();
    } on GoogleSignInException catch (error) {
      // A user-cancelled sign-in is not an error; anything else propagates.
      if (error.code == GoogleSignInExceptionCode.canceled) return;
      rethrow;
    }
  }

  @override
  Future<void> restore() async {
    await _googleSignIn.attemptLightweightAuthentication();
  }

  @override
  Future<void> signOut() => _googleSignIn.signOut();
}
