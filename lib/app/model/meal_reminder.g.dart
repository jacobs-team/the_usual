// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MealReminder _$MealReminderFromJson(Map<String, dynamic> json) =>
    _MealReminder(
      enabled: json['enabled'] as bool,
      time: const TimeOfDayConverter().fromJson(
        json['time'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$MealReminderToJson(_MealReminder instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'time': const TimeOfDayConverter().toJson(instance.time),
    };
