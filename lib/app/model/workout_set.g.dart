// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkoutSet _$WorkoutSetFromJson(Map<String, dynamic> json) => _WorkoutSet(
  weight: (json['weight'] as num?)?.toDouble(),
  reps: (json['reps'] as num?)?.toInt(),
  weightAutoEstimated: json['weightAutoEstimated'] as bool? ?? false,
);

Map<String, dynamic> _$WorkoutSetToJson(_WorkoutSet instance) =>
    <String, dynamic>{
      'weight': instance.weight,
      'reps': instance.reps,
      'weightAutoEstimated': instance.weightAutoEstimated,
    };
