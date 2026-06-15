// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_log_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MealLogEntry _$MealLogEntryFromJson(Map<String, dynamic> json) =>
    _MealLogEntry(
      id: json['id'] as String,
      loggedAt: DateTime.parse(json['loggedAt'] as String),
      mealOfTheDay: $enumDecode(_$MealOfTheDayEnumMap, json['mealOfTheDay']),
      name: json['name'] as String,
      nutrition: json['nutrition'] == null
          ? const Nutrition()
          : Nutrition.fromJson(json['nutrition'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      usualMealId: json['usualMealId'] as String?,
      photoPath: json['photoPath'] as String?,
    );

Map<String, dynamic> _$MealLogEntryToJson(_MealLogEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'loggedAt': instance.loggedAt.toIso8601String(),
      'mealOfTheDay': _$MealOfTheDayEnumMap[instance.mealOfTheDay]!,
      'name': instance.name,
      'nutrition': instance.nutrition.toJson(),
      'quantity': instance.quantity,
      'usualMealId': instance.usualMealId,
      'photoPath': instance.photoPath,
    };

const _$MealOfTheDayEnumMap = {
  MealOfTheDay.breakfast: 'breakfast',
  MealOfTheDay.lunch: 'lunch',
  MealOfTheDay.dinner: 'dinner',
  MealOfTheDay.snacks: 'snacks',
};
