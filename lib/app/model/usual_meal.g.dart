// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usual_meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UsualMeal _$UsualMealFromJson(Map<String, dynamic> json) => _UsualMeal(
  id: json['id'] as String,
  name: json['name'] as String,
  photoPath: json['photoPath'] as String?,
  nutrition: json['nutrition'] == null
      ? const Nutrition()
      : Nutrition.fromJson(json['nutrition'] as Map<String, dynamic>),
  components:
      (json['components'] as List<dynamic>?)
          ?.map((e) => MealComponent.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <MealComponent>[],
);

Map<String, dynamic> _$UsualMealToJson(_UsualMeal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'photoPath': instance.photoPath,
      'nutrition': instance.nutrition.toJson(),
      'components': instance.components.map((e) => e.toJson()).toList(),
    };
