import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_usual/app/model/model.dart';

part 'workout_reminder.freezed.dart';
part 'workout_reminder.g.dart';

/// {@template workout_reminder}
/// The workout check-in reminder: whether it is on, which days of the week it
/// fires (1 = Monday … 7 = Sunday), and at what time.
/// {@endtemplate}
@freezed
abstract class WorkoutReminder with _$WorkoutReminder {
  /// {@macro workout_reminder}
  const factory WorkoutReminder({
    @TimeOfDayConverter() required TimeOfDay timeOfDay, @Default(false) bool enabled,
    @Default(<int>{}) Set<int> daysOfWeek,
  }) = _WorkoutReminder;

  factory WorkoutReminder.fromJson(Map<String, dynamic> json) =>
      _$WorkoutReminderFromJson(json);
}
