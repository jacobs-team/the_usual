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

/// {@template auth_cubit}
/// Holds the app's authentication state and drives the router. Subscribes to
/// [AuthRepository.authChanges] and persists the durable result; transient
/// progress and errors live in the views that call its methods.
/// {@endtemplate}
@singleton
class AuthCubit extends HydratedCubit<AuthState> implements Listenable {
  /// {@macro auth_cubit}
  AuthCubit(this._repository) : super(const AuthState()) {
    _subscription = _repository.authChanges.listen(_onAuthChanged);
  }

  final AuthRepository _repository;
  StreamSubscription<AuthUser?>? _subscription;
  final List<VoidCallback> _listeners = [];

  /// Cancels in-flight HTTP requests on sign-out.
  CancelToken cancelToken = CancelToken();

  void _onAuthChanged(AuthUser? user) {
    if (user != null) {
      emit(state.copyWith(status: AuthStatus.signedIn, user: user));
    } else if (state.status == AuthStatus.signedIn) {
      // The SDK signed out; keep the user in the app as a guest rather than
      // bouncing them back to the one-time sign-in gate.
      emit(state.copyWith(status: AuthStatus.guest, user: null));
    }
  }

  /// Initializes the SDK and restores a previous session silently. Call once at
  /// app start.
  Future<void> restoreOnStartup() async {
    try {
      await _repository.initialize();
      await _repository.restore();
    } on Exception {
      // A failed silent restore leaves the persisted state untouched.
    }
  }

  /// Triggers the interactive Google sign-in flow. The result arrives via the
  /// repository stream. Throws on failure so the caller can surface it.
  Future<void> signInWithGoogle() async {
    await _repository.initialize();
    await _repository.signIn();
  }

  /// Records that the user chose to continue without an account.
  void continueAsGuest() =>
      emit(state.copyWith(status: AuthStatus.guest, user: null));

  /// Signs out of Google and cancels active requests; the user stays in the app
  /// as a guest.
  Future<void> signOut() async {
    cancelToken.cancel('Signed out');
    cancelToken = CancelToken();
    await _repository.signOut();
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
/// [user].
/// {@endtemplate}
@freezed
abstract class AuthState with _$AuthState {
  /// {@macro auth_state}
  @JsonSerializable(explicitToJson: true)
  const factory AuthState({
    @Default(2) int version,
    @Default(AuthStatus.unknown) AuthStatus status,
    AuthUser? user,
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
