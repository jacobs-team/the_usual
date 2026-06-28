// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_log_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyLogState _$DailyLogStateFromJson(Map<String, dynamic> json) =>
    _DailyLogState(
      version: (json['version'] as num?)?.toInt() ?? 2,
      mealEntries:
          (json['mealEntries'] as List<dynamic>?)
              ?.map((e) => MealLogEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MealLogEntry>[],
      weightEntries:
          (json['weightEntries'] as List<dynamic>?)
              ?.map((e) => WeightEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <WeightEntry>[],
    );

Map<String, dynamic> _$DailyLogStateToJson(_DailyLogState instance) =>
    <String, dynamic>{
      'version': instance.version,
      'mealEntries': instance.mealEntries.map((e) => e.toJson()).toList(),
      'weightEntries': instance.weightEntries.map((e) => e.toJson()).toList(),
    };
