import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part 'auth_cubit.freezed.dart';
part 'auth_cubit.g.dart';

/// {@template auth_cubit}
/// A [HydratedCubit] responsible for managing the authentication state of the
/// application.
///
/// This cubit persists the [AuthState] across app restarts and provides
/// methods to handle user sessions and logout logic.
/// {@endtemplate}
@singleton
class AuthCubit extends HydratedCubit<AuthState> implements Listenable {
  /// {@macro auth_cubit}
  AuthCubit() : super(const AuthState());

  final List<VoidCallback> _listeners = [];

  /// A [CancelToken] used to abort ongoing HTTP requests when
  /// the user logs out.
  CancelToken cancelToken = CancelToken();

  /// Updates the current state with the provided [user] and [token].
  void setSession(String user, String token) {
    emit(AuthState(token: token, user: user));
  }

  /// Clears the authentication state and cancels any active requests.
  Future<void> logout() async {
    cancelToken.cancel('Logged out');
    cancelToken = CancelToken();
    emit(const AuthState());
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
/// Represents the state of the authentication flow.
///
/// Includes the [user] identifier and the session [token].
/// {@endtemplate}
@freezed
abstract class AuthState with _$AuthState {
  /// {@macro auth_state}
  const factory AuthState({
    /// Schema version of the persisted state. Bump it and add a `fromJson`
    /// case whenever the persisted shape changes in a way old stored data
    /// can't be read as-is, so existing users are migrated instead of reset.
    @Default(1) int version,
    String? user,
    String? token,
  }) = _AuthState;

  const AuthState._();

  /// The version written by the current app.
  static const _currentVersion = 1;

  /// Returns true if both [user] and [token] are present.
  bool get signedIn => user != null && token != null;

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      AuthState._fromVersionedJson(json);

  factory AuthState._fromVersionedJson(Map<String, dynamic> json) {
    final version = json['version'] as int? ?? 0;
    switch (version) {
      // No migrations yet. v0 is unversioned data written before this field
      // existed; it has the current shape and reads straight through. When the
      // shape changes, bump [_currentVersion] and add a case that migrates
      // older versions up to the current one before this case.
      case 0:
      case _currentVersion:
        return _$AuthStateFromJson(json);
      default:
        // A newer, unknown version, e.g. after the user downgrades the app.
        // Read it with the current schema as a best effort rather than
        // discarding the session and forcing a logout: unknown keys are
        // ignored and missing ones fall back to defaults.
        return _$AuthStateFromJson(json);
    }
  }
}
