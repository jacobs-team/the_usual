// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usual_food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UsualFood _$UsualFoodFromJson(Map<String, dynamic> json) => _UsualFood(
  id: json['id'] as String,
  name: json['name'] as String,
  nutrition: json['nutrition'] == null
      ? const Nutrition()
      : Nutrition.fromJson(json['nutrition'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UsualFoodToJson(_UsualFood instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nutrition': instance.nutrition.toJson(),
    };
