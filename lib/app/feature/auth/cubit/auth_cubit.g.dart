// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthState _$AuthStateFromJson(Map<String, dynamic> json) => _AuthState(
  version: (json['version'] as num?)?.toInt() ?? 2,
  status:
      $enumDecodeNullable(_$AuthStatusEnumMap, json['status']) ??
      AuthStatus.unknown,
  user: json['user'] == null
      ? null
      : AuthUser.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthStateToJson(_AuthState instance) =>
    <String, dynamic>{
      'version': instance.version,
      'status': _$AuthStatusEnumMap[instance.status]!,
      'user': instance.user?.toJson(),
    };

const _$AuthStatusEnumMap = {
  AuthStatus.unknown: 'unknown',
  AuthStatus.signedIn: 'signedIn',
  AuthStatus.guest: 'guest',
};
