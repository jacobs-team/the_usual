// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calorie_goal_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CalorieGoalEntry _$CalorieGoalEntryFromJson(Map<String, dynamic> json) =>
    _CalorieGoalEntry(
      effectiveFrom: DateTime.parse(json['effectiveFrom'] as String),
      calories: (json['calories'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CalorieGoalEntryToJson(_CalorieGoalEntry instance) =>
    <String, dynamic>{
      'effectiveFrom': instance.effectiveFrom.toIso8601String(),
      'calories': instance.calories,
    };
