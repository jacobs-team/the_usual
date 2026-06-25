// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_goal_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeightGoalEntry _$WeightGoalEntryFromJson(Map<String, dynamic> json) =>
    _WeightGoalEntry(
      effectiveFrom: DateTime.parse(json['effectiveFrom'] as String),
      weightUnit: $enumDecode(_$WeightUnitEnumMap, json['weightUnit']),
      weight: (json['weight'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$WeightGoalEntryToJson(_WeightGoalEntry instance) =>
    <String, dynamic>{
      'effectiveFrom': instance.effectiveFrom.toIso8601String(),
      'weightUnit': _$WeightUnitEnumMap[instance.weightUnit]!,
      'weight': instance.weight,
    };

const _$WeightUnitEnumMap = {WeightUnit.lb: 'lb', WeightUnit.kg: 'kg'};
