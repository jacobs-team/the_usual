// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeightEntry _$WeightEntryFromJson(Map<String, dynamic> json) => _WeightEntry(
  id: json['id'] as String,
  loggedAt: DateTime.parse(json['loggedAt'] as String),
  weight: (json['weight'] as num).toDouble(),
  weightUnit: $enumDecode(_$WeightUnitEnumMap, json['weightUnit']),
);

Map<String, dynamic> _$WeightEntryToJson(_WeightEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'loggedAt': instance.loggedAt.toIso8601String(),
      'weight': instance.weight,
      'weightUnit': _$WeightUnitEnumMap[instance.weightUnit]!,
    };

const _$WeightUnitEnumMap = {WeightUnit.lb: 'lb', WeightUnit.kg: 'kg'};
