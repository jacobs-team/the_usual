// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthState _$AuthStateFromJson(Map<String, dynamic> json) => _AuthState(
  version: (json['version'] as num?)?.toInt() ?? 1,
  user: json['user'] as String?,
  token: json['token'] as String?,
);

Map<String, dynamic> _$AuthStateToJson(_AuthState instance) =>
    <String, dynamic>{
      'version': instance.version,
      'user': instance.user,
      'token': instance.token,
    };
