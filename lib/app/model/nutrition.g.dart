// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Nutrition _$NutritionFromJson(Map<String, dynamic> json) => _Nutrition(
  calories: (json['calories'] as num?)?.toDouble(),
  protein: (json['protein'] as num?)?.toDouble(),
  fat: (json['fat'] as num?)?.toDouble(),
  carbs: (json['carbs'] as num?)?.toDouble(),
);

Map<String, dynamic> _$NutritionToJson(_Nutrition instance) =>
    <String, dynamic>{
      'calories': instance.calories,
      'protein': instance.protein,
      'fat': instance.fat,
      'carbs': instance.carbs,
    };
