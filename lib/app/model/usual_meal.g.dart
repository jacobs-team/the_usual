// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usual_meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UsualMeal _$UsualMealFromJson(Map<String, dynamic> json) => _UsualMeal(
  id: json['id'] as String,
  name: json['name'] as String,
  photoPath: json['photoPath'] as String?,
  calories: (json['calories'] as num?)?.toInt(),
);

Map<String, dynamic> _$UsualMealToJson(_UsualMeal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'photoPath': instance.photoPath,
      'calories': instance.calories,
    };
