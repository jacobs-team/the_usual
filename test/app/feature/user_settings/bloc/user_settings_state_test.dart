import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(UserSettingsState, () {
    test('dayStartTime defaults to midnight', () {
      expect(
        const UserSettingsState().dayStartTime,
        equals(const TimeOfDay(hour: 0, minute: 0)),
      );
    });

    group('fromJson', () {
      test('reads current-version data straight through', () {
        final restored = UserSettingsState.fromJson(
          const UserSettingsState(calorieGoal: 2000).toJson(),
        );

        expect(restored.calorieGoal, equals(2000));
      });

      test('reads a newer unknown version as a best effort', () {
        final json = const UserSettingsState(calorieGoal: 1800).toJson()
          ..['version'] = 99;

        final restored = UserSettingsState.fromJson(json);

        expect(restored.calorieGoal, equals(1800));
      });

      test('maps the removed onAppOpen reminder style to none', () {
        final json = const UserSettingsState().toJson()
          ..['reminderStyle'] = 'onAppOpen';

        final restored = UserSettingsState.fromJson(json);

        expect(restored.reminderStyle, equals(ReminderStyle.none));
      });
    });

    group('currentMeal', () {
      test('falls back to the meal time when there are no boundaries', () {
        const state = UserSettingsState(
          mealCheckinScheduleMode: MealCheckinScheduleMode.endOfDay,
        );
        final lunchTime = DateTime(2026, 6, 17, 13);

        expect(
          state.currentMeal(lunchTime),
          equals(MealOfTheDay.fromTime(TimeOfDay.fromDateTime(lunchTime))),
        );
      });

      test('rests on the first meal before any reminder has fired', () {
        const state = UserSettingsState();
        final earlyMorning = DateTime(2026, 6, 17, 6);

        expect(
          state.currentMeal(earlyMorning),
          equals(MealOfTheDay.breakfast),
        );
      });

      test('moves to the latest meal whose reminder has passed', () {
        const state = UserSettingsState();
        final afternoon = DateTime(2026, 6, 17, 15);

        expect(state.currentMeal(afternoon), equals(MealOfTheDay.lunch));
      });
    });

    group('nextMealBoundary', () {
      test('returns the top of the next hour with no boundaries', () {
        const state = UserSettingsState(
          mealCheckinScheduleMode: MealCheckinScheduleMode.endOfDay,
        );
        final now = DateTime(2026, 6, 17, 13, 20);

        expect(
          state.nextMealBoundary(now),
          equals(DateTime(2026, 6, 17, 14)),
        );
      });

      test('returns the next later reminder still ahead', () {
        const state = UserSettingsState();
        final morning = DateTime(2026, 6, 17, 10);

        expect(
          state.nextMealBoundary(morning),
          equals(DateTime(2026, 6, 17, 14)),
        );
      });

      test('returns the next midnight once every later reminder passed', () {
        const state = UserSettingsState();
        final lateEvening = DateTime(2026, 6, 17, 23);

        expect(
          state.nextMealBoundary(lateEvening),
          equals(DateTime(2026, 6, 18)),
        );
      });
    });
  });
}
