// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usual_workout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UsualWorkout _$UsualWorkoutFromJson(Map<String, dynamic> json) =>
    _UsualWorkout(
      id: json['id'] as String,
      name: json['name'] as String,
      sets:
          (json['sets'] as List<dynamic>?)
              ?.map((e) => WorkoutSet.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <WorkoutSet>[],
    );

Map<String, dynamic> _$UsualWorkoutToJson(_UsualWorkout instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sets': instance.sets.map((e) => e.toJson()).toList(),
    };
