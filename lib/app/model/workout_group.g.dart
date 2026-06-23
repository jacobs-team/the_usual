// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkoutGroup _$WorkoutGroupFromJson(Map<String, dynamic> json) =>
    _WorkoutGroup(
      id: json['id'] as String,
      name: json['name'] as String,
      order: (json['order'] as num).toInt(),
    );

Map<String, dynamic> _$WorkoutGroupToJson(_WorkoutGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'order': instance.order,
    };
