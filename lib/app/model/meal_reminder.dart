import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal_reminder.freezed.dart';
part 'meal_reminder.g.dart';

/// Serializes [TimeOfDay] as a `{hour, minute}` map. [TimeOfDay] has no
/// built-in json support, unlike [DateTime].
class TimeOfDayConverter
    implements JsonConverter<TimeOfDay, Map<String, dynamic>> {
  /// Creates a [TimeOfDayConverter].
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(Map<String, dynamic> json) {
    return TimeOfDay(hour: json['hour'] as int, minute: json['minute'] as int);
  }

  @override
  Map<String, dynamic> toJson(TimeOfDay object) {
    return {'hour': object.hour, 'minute': object.minute};
  }
}

/// {@template meal_reminder}
/// A reminder slot: whether it is on and what time it fires.
/// {@endtemplate}
@freezed
abstract class MealReminder with _$MealReminder {
  /// {@macro meal_reminder}
  const factory MealReminder({
    required bool enabled,
    @TimeOfDayConverter() required TimeOfDay time,
  }) = _MealReminder;

  factory MealReminder.fromJson(Map<String, dynamic> json) =>
      _$MealReminderFromJson(json);
}
