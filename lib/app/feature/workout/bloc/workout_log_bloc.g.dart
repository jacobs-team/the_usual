// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_log_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkoutLogState _$WorkoutLogStateFromJson(Map<String, dynamic> json) =>
    _WorkoutLogState(
      version: (json['version'] as num?)?.toInt() ?? 1,
      workoutEntries:
          (json['workoutEntries'] as List<dynamic>?)
              ?.map((e) => WorkoutLogEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <WorkoutLogEntry>[],
    );

Map<String, dynamic> _$WorkoutLogStateToJson(_WorkoutLogState instance) =>
    <String, dynamic>{
      'version': instance.version,
      'workoutEntries': instance.workoutEntries.map((e) => e.toJson()).toList(),
    };
