// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_meal_suggestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiMealSuggestion _$AiMealSuggestionFromJson(Map<String, dynamic> json) =>
    _AiMealSuggestion(
      name: json['name'] as String,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 1,
      nutrition: json['nutrition'] == null
          ? const Nutrition()
          : Nutrition.fromJson(json['nutrition'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AiMealSuggestionToJson(_AiMealSuggestion instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'nutrition': instance.nutrition.toJson(),
    };
