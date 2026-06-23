// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkoutReminder _$WorkoutReminderFromJson(Map<String, dynamic> json) =>
    _WorkoutReminder(
      enabled: json['enabled'] as bool? ?? false,
      daysOfWeek:
          (json['daysOfWeek'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toSet() ??
          const <int>{},
      timeOfDay: const TimeOfDayConverter().fromJson(
        json['timeOfDay'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$WorkoutReminderToJson(_WorkoutReminder instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'daysOfWeek': instance.daysOfWeek.toList(),
      'timeOfDay': const TimeOfDayConverter().toJson(instance.timeOfDay),
    };
