// ignore_for_file: public_member_api_docs

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
    String? user,
    String? token,
  }) = _AuthState;

  const AuthState._();

  /// Returns true if both [user] and [token] are present.
  bool get signedIn => user != null && token != null;

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);
}
