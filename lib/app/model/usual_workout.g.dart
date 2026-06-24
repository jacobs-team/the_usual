// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usual_workout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UsualWorkout _$UsualWorkoutFromJson(Map<String, dynamic> json) =>
    _UsualWorkout(
      id: json['id'] as String,
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
    );

Map<String, dynamic> _$UsualWorkoutToJson(_UsualWorkout instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$WorkoutTypeEnumMap[instance.type]!,
      'sets': instance.sets.map((e) => e.toJson()).toList(),
      'duration': instance.duration?.inMicroseconds,
    };

const _$WorkoutTypeEnumMap = {
  WorkoutType.strength: 'strength',
  WorkoutType.cardio: 'cardio',
};
