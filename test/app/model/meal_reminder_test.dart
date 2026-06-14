import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(MealReminder, () {
    test('round-trips through json with a TimeOfDay', () {
      const mealReminder = MealReminder(
        enabled: true,
        timeOfDay: TimeOfDay(hour: 9, minute: 30),
      );

      final decoded = MealReminder.fromJson(mealReminder.toJson());

      expect(decoded, equals(mealReminder));
    });
  });

  group(TimeOfDayConverter, () {
    const converter = TimeOfDayConverter();

    test('fromJson reads hour and minute', () {
      expect(
        converter.fromJson(<String, dynamic>{'hour': 7, 'minute': 15}),
        equals(const TimeOfDay(hour: 7, minute: 15)),
      );
    });

    test('toJson writes hour and minute', () {
      expect(
        converter.toJson(const TimeOfDay(hour: 18, minute: 45)),
        equals(<String, dynamic>{'hour': 18, 'minute': 45}),
      );
    });
  });
}
