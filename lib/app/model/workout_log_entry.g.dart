// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_log_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkoutLogEntry _$WorkoutLogEntryFromJson(Map<String, dynamic> json) =>
    _WorkoutLogEntry(
      id: json['id'] as String,
      loggedAt: DateTime.parse(json['loggedAt'] as String),
      workoutGroupId: json['workoutGroupId'] as String,
      name: json['name'] as String,
      type:
          $enumDecodeNullable(_$WorkoutTypeEnumMap, json['type']) ??
          WorkoutType.strength,
      sets:
          (json['sets'] as List<dynamic>?)
              ?.map((e) => WorkoutSet.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <WorkoutSet>[],
      duration: json['duration'] == null
          ? null
          : Duration(microseconds: (json['duration'] as num).toInt()),
      usualWorkoutId: json['usualWorkoutId'] as String?,
    );

Map<String, dynamic> _$WorkoutLogEntryToJson(_WorkoutLogEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'loggedAt': instance.loggedAt.toIso8601String(),
      'workoutGroupId': instance.workoutGroupId,
      'name': instance.name,
      'type': _$WorkoutTypeEnumMap[instance.type]!,
      'sets': instance.sets.map((e) => e.toJson()).toList(),
      'duration': instance.duration?.inMicroseconds,
      'usualWorkoutId': instance.usualWorkoutId,
    };

const _$WorkoutTypeEnumMap = {
  WorkoutType.strength: 'strength',
  WorkoutType.cardio: 'cardio',
};
