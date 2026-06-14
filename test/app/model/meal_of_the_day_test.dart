import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(MealOfTheDay, () {
    test('exposes a display label for each meal', () {
      expect(MealOfTheDay.breakfast.label, equals('Breakfast'));
      expect(MealOfTheDay.lunch.label, equals('Lunch'));
      expect(MealOfTheDay.dinner.label, equals('Dinner'));
      expect(MealOfTheDay.snacks.label, equals('Snacks'));
    });

    group('fromTime', () {
      test('returns dinner at or after 7pm', () {
        expect(
          MealOfTheDay.fromTime(const TimeOfDay(hour: 19, minute: 0)),
          equals(MealOfTheDay.dinner),
        );
        expect(
          MealOfTheDay.fromTime(const TimeOfDay(hour: 23, minute: 30)),
          equals(MealOfTheDay.dinner),
        );
      });

      test('returns lunch between 2pm and 7pm', () {
        expect(
          MealOfTheDay.fromTime(const TimeOfDay(hour: 14, minute: 0)),
          equals(MealOfTheDay.lunch),
        );
        expect(
          MealOfTheDay.fromTime(const TimeOfDay(hour: 18, minute: 59)),
          equals(MealOfTheDay.lunch),
        );
      });

      test('returns breakfast before 2pm', () {
        expect(
          MealOfTheDay.fromTime(const TimeOfDay(hour: 0, minute: 0)),
          equals(MealOfTheDay.breakfast),
        );
        expect(
          MealOfTheDay.fromTime(const TimeOfDay(hour: 13, minute: 59)),
          equals(MealOfTheDay.breakfast),
        );
      });
    });
  });
}
