// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_component.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MealComponent _$MealComponentFromJson(Map<String, dynamic> json) =>
    _MealComponent(
      name: json['name'] as String,
      nutrition: json['nutrition'] == null
          ? const Nutrition()
          : Nutrition.fromJson(json['nutrition'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num?)?.toDouble() ?? 1,
      usualFoodId: json['usualFoodId'] as String?,
    );

Map<String, dynamic> _$MealComponentToJson(_MealComponent instance) =>
    <String, dynamic>{
      'name': instance.name,
      'nutrition': instance.nutrition.toJson(),
      'quantity': instance.quantity,
      'usualFoodId': instance.usualFoodId,
    };
