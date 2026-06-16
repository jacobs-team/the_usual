// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dev_tools_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DevToolsState _$DevToolsStateFromJson(Map<String, dynamic> json) =>
    _DevToolsState(
      version: (json['version'] as num?)?.toInt() ?? 1,
      isApiDebug: json['isApiDebug'] as bool? ?? true,
    );

Map<String, dynamic> _$DevToolsStateToJson(_DevToolsState instance) =>
    <String, dynamic>{
      'version': instance.version,
      'isApiDebug': instance.isApiDebug,
    };
