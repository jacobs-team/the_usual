import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:the_usual/app/app.dart';

part 'auth_cubit.freezed.dart';
part 'auth_cubit.g.dart';

/// How the user relates to an account, persisted across restarts.
enum AuthStatus {
  /// No decision yet — the one-time sign-in screen should be offered.
  unknown,

  /// Signed in with Google.
  signedIn,

  /// Chose to use the app without an account.
  guest,
}

/// A one-shot prompt the UI turns into a dialog mid sign-in. Not persisted.
enum SignInPrompt {
  /// New account with established guest data: keep it or start fresh.
  keepOrStartFresh,

  /// Existing account with cloud data: signing in replaces local guest data,
  /// which is lost.
  replaceLocalWithCloud,
}

/// Thrown when sign-out is attempted offline, where we cannot confirm the cloud
/// holds the latest data before clearing local state.
class SignOutOfflineException implements Exception {
  /// {@macro sign_out_offline_exception}
  const SignOutOfflineException();
}

/// {@template auth_cubit}
/// Holds the app's authentication state and drives the router. Orchestrates the
/// sign-in branch (new vs existing account, the guest-data dialogs, and the
/// cloud download/upload) via [AuthRepository] and [SyncRepository], and
/// persists the durable result; transient progress lives in the views.
/// {@endtemplate}
@singleton
class AuthCubit extends HydratedCubit<AuthState> implements Listenable {
  /// {@macro auth_cubit}
  AuthCubit(this._authRepository, this._syncRepository, this._connectivityCubit)
    : super(const AuthState()) {
    _subscription = _authRepository.authChanges.listen(_onAuthChanged);
  }

  final AuthRepository _authRepository;
  final SyncRepository _syncRepository;
  final ConnectivityCubit _connectivityCubit;
  StreamSubscription<AuthUser?>? _subscription;
  final List<VoidCallback> _listeners = [];

  /// True while an interactive sign-in is mid-flow, so the Firebase auth stream
  /// (which fires the instant we sign in with a credential) doesn't flip the
  /// app to signed-in before the migration and any dialog resolve.
  bool _interactiveSignInInProgress = false;
  String? _pendingUid;
  AuthUser? _pendingUser;

  final Completer<void> _ready = Completer<void>();

  /// Completes once the initial auth state is resolved on startup: a persisted
  /// session restored and its cloud data synced, or confirmed signed-out. The
  /// app holds the native splash until this completes.
  Future<void> get ready => _ready.future;

  void _markReady() {
    if (!_ready.isCompleted) _ready.complete();
  }

  /// Cancels in-flight HTTP requests on sign-out.
  CancelToken cancelToken = CancelToken();

  void _onAuthChanged(AuthUser? user) {
    // The interactive flow drives state itself; ignore the credential echo.
    if (_interactiveSignInInProgress) return;
    if (user != null) {
      if (state.status == AuthStatus.signedIn) {
        // Normal relaunch: local data and onboarding are intact; just resync.
        _syncRepository.startWatching(user.id);
        _markReady();
      } else {
        // A persisted Firebase session on otherwise-fresh local state (e.g. a
        // reinstall): pull cloud data and restore onboarding before syncing.
        unawaited(_resumePersistedSession(user));
      }
    } else {
      // Signed out elsewhere (e.g. revoked token): drop to guest.
      if (state.status == AuthStatus.signedIn) {
        _syncRepository.stopWatching();
        emit(state.copyWith(status: AuthStatus.guest, user: null));
      }
      _markReady();
    }
  }

  /// Resumes a persisted session whose local state was wiped (a reinstall). The
  /// Firebase session survives in the keychain but onboarding completion does
  /// not, so we download the cloud data and, when it is established, mark
  /// onboarding complete without re-running its draft commit.
  Future<void> _resumePersistedSession(AuthUser user) async {
    emit(state.copyWith(status: AuthStatus.signedIn, user: user));
    try {
      final established = await _syncRepository.downloadAndApply(user.id);
      if (established) await _syncRepository.markOnboardingComplete();
    } on Exception {
      // Offline or read failure: the live subscription still pulls when able.
    }
    _syncRepository.startWatching(user.id);
    _markReady();
  }

  /// Initializes the sign-in SDK. Call once at app start. A persisted session
  /// is restored automatically through [AuthRepository.authChanges].
  Future<void> restoreOnStartup() async {
    try {
      await _authRepository.initialize();
    } on Exception {
      // A failed init leaves persisted state untouched; the auth stream still
      // resumes a session if one exists.
    }
  }

  /// Runs the interactive Google sign-in and branches on whether the account is
  /// new or existing, uploading guest data, downloading cloud data, or raising
  /// a dialog. Throws on failure so the caller can surface it.
  Future<void> signInWithGoogle() async {
    await _authRepository.initialize();
    _interactiveSignInInProgress = true;
    try {
      final result = await _authRepository.signIn();
      if (result == null) {
        _interactiveSignInInProgress = false;
        return;
      }
      final uid = result.user.id;
      _pendingUid = uid;
      _pendingUser = result.user;

      // A returning Auth record with no document is treated as new, so a
      // deleted or never-written cloud doc can't replace local data with
      // nothing.
      final hasCloudDoc = await _syncRepository.cloudDocExists(uid);
      final isNewAccount = result.isNewUser || !hasCloudDoc;

      if (isNewAccount) {
        if (_syncRepository.hasEstablishedData) {
          emit(state.copyWith(pendingPrompt: SignInPrompt.keepOrStartFresh));
        } else {
          await _syncRepository.uploadLocal(uid);
          _syncRepository.resetOnboarding();
          _completeSignIn();
        }
      } else {
        if (_syncRepository.hasEstablishedData) {
          emit(
            state.copyWith(pendingPrompt: SignInPrompt.replaceLocalWithCloud),
          );
        } else {
          await _applyExistingAccount(uid);
        }
      }
    } catch (_) {
      _interactiveSignInInProgress = false;
      rethrow;
    }
  }

  /// New account, "keep my data": uploads the guest data as the account's first
  /// cloud document.
  Future<void> keepGuestData() async {
    final uid = _pendingUid;
    if (uid == null) return;
    await _syncRepository.uploadLocal(uid);
    _completeSignIn();
  }

  /// New account, "start fresh": discards local guest data and starts an empty
  /// cloud account, routing back through onboarding.
  Future<void> startFresh() async {
    final uid = _pendingUid;
    if (uid == null) return;
    await _syncRepository.clearLocal();
    await _syncRepository.uploadLocal(uid);
    _completeSignIn();
  }

  /// Existing account, confirmed: downloads the cloud data over local, which is
  /// lost.
  Future<void> confirmReplaceWithCloud() async {
    final uid = _pendingUid;
    if (uid == null) return;
    await _applyExistingAccount(uid);
  }

  /// Downloads an existing account's cloud data and resolves onboarding from
  /// it: established data skips onboarding (the user has used the app before),
  /// empty data routes through it. Then signs in.
  Future<void> _applyExistingAccount(String uid) async {
    final established = await _syncRepository.downloadAndApply(uid);
    if (established) {
      await _syncRepository.markOnboardingComplete();
    } else {
      _syncRepository.resetOnboarding();
    }
    _completeSignIn();
  }

  /// Backs out of signing into an existing account, keeping local guest data.
  Future<void> cancelSignIn() async {
    await _authRepository.signOut();
    _pendingUid = null;
    _pendingUser = null;
    _interactiveSignInInProgress = false;
    emit(state.copyWith(pendingPrompt: null));
  }

  void _completeSignIn() {
    final user = _pendingUser;
    final uid = _pendingUid;
    _pendingUser = null;
    _pendingUid = null;
    _interactiveSignInInProgress = false;
    if (user == null || uid == null) return;
    emit(
      state.copyWith(
        status: AuthStatus.signedIn,
        user: user,
        pendingPrompt: null,
      ),
    );
    _syncRepository.startWatching(uid);
  }

  /// Records that the user chose to continue without an account.
  void continueAsGuest() =>
      emit(state.copyWith(status: AuthStatus.guest, user: null));

  /// Signs out: confirms the cloud holds the latest data, then clears local
  /// state and returns to a fresh guest. Throws [SignOutOfflineException] when
  /// offline, since the cloud cannot be confirmed current.
  Future<void> signOut() async {
    final uid = state.user?.id;
    if (uid != null) {
      if (!_connectivityCubit.state) throw const SignOutOfflineException();
      await _syncRepository.flushAndConfirm(uid);
    }
    cancelToken.cancel('Signed out');
    cancelToken = CancelToken();
    _syncRepository.stopWatching();
    await _authRepository.signOut();
    await _syncRepository.clearLocal();
    emit(state.copyWith(status: AuthStatus.guest, user: null));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }

  @override
  AuthState fromJson(Map<String, dynamic> json) => AuthState.fromJson(json);

  @override
  Map<String, dynamic> toJson(AuthState state) => state.toJson();

  @override
  void addListener(VoidCallback listener) => _listeners.add(listener);

  @override
  void removeListener(VoidCallback listener) => _listeners.remove(listener);

  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
    for (final listener in _listeners) {
      listener();
    }
  }
}

/// {@template auth_state}
/// The authentication state: the user's [status] and, when signed in, their
/// [user]. [pendingPrompt] is a transient signal for the sign-in dialogs and is
/// not persisted.
/// {@endtemplate}
@freezed
abstract class AuthState with _$AuthState {
  /// {@macro auth_state}
  @JsonSerializable(explicitToJson: true)
  const factory AuthState({
    @Default(2) int version,
    @Default(AuthStatus.unknown) AuthStatus status,
    AuthUser? user,
    @JsonKey(includeFromJson: false, includeToJson: false)
    SignInPrompt? pendingPrompt,
  }) = _AuthState;

  const AuthState._();

  static const _currentVersion = 2;

  /// Whether the user is signed in with Google.
  bool get signedIn => status == AuthStatus.signedIn;

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      AuthState._fromVersionedJson(json);

  factory AuthState._fromVersionedJson(Map<String, dynamic> json) {
    final version = json['version'] as int? ?? 0;
    switch (version) {
      case 0:
      case 1:
        // v0/v1 stored a placeholder {user, token} string pair with no real
        // Google identity. Discard it and start unknown rather than fabricate
        // a signed-in state.
        return const AuthState();
      case _currentVersion:
        return _$AuthStateFromJson(json);
      default:
        // A newer, unknown version (e.g. a downgrade): read with the current
        // schema as a best effort instead of discarding.
        return _$AuthStateFromJson(json);
    }
  }
}
