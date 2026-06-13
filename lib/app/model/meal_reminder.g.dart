// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MealReminder _$MealReminderFromJson(Map<String, dynamic> json) =>
    _MealReminder(
      enabled: json['enabled'] as bool,
      timeOfDay: const TimeOfDayConverter().fromJson(
        json['timeOfDay'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$MealReminderToJson(_MealReminder instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'timeOfDay': const TimeOfDayConverter().toJson(instance.timeOfDay),
    };
