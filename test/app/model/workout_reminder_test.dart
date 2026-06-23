import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(WorkoutReminder, () {
    test('round-trips through json', () {
      const workoutReminder = WorkoutReminder(
        enabled: true,
        daysOfWeek: {1, 3, 5},
        timeOfDay: TimeOfDay(hour: 18, minute: 0),
      );

      expect(
        WorkoutReminder.fromJson(workoutReminder.toJson()),
        equals(workoutReminder),
      );
    });

    test('defaults to disabled with no days', () {
      const workoutReminder = WorkoutReminder(
        timeOfDay: TimeOfDay(hour: 18, minute: 0),
      );

      expect(workoutReminder.enabled, isFalse);
      expect(workoutReminder.daysOfWeek, isEmpty);
    });
  });
}
