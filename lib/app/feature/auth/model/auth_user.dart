import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

/// {@template auth_user}
/// The signed-in Google identity, as the app uses it: a stable id, email, and
/// optional display name and avatar. Mapped from the SDK account by
/// `AuthRepository` so the rest of the app never sees google_sign_in types.
/// {@endtemplate}
@freezed
abstract class AuthUser with _$AuthUser {
  /// {@macro auth_user}
  const factory AuthUser({
    required String id,
    required String email,
    String? displayName,
    String? photoUrl,
  }) = _AuthUser;

  /// Reads an [AuthUser] from persisted JSON.
  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
}
