import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(UserSettingsBloc, () {
    setUp(initHydratedStorage);

    test('initial state is the default UserSettingsState', () {
      expect(UserSettingsBloc().state, equals(const UserSettingsState()));
    });

    blocTest<UserSettingsBloc, UserSettingsState>(
      'settingsCommitted replaces the whole state',
      build: UserSettingsBloc.new,
      act: (bloc) => bloc.add(
        const UserSettingsEvent.settingsCommitted(
          UserSettingsState(weightUnit: WeightUnit.kg),
        ),
      ),
      expect: () => [
        const UserSettingsState(weightUnit: WeightUnit.kg),
      ],
    );

    blocTest<UserSettingsBloc, UserSettingsState>(
      'reminderStyleSelected stores the chosen style',
      build: UserSettingsBloc.new,
      act: (bloc) => bloc.add(
        const UserSettingsEvent.reminderStyleSelected(ReminderStyle.none),
      ),
      expect: () => [
        isA<UserSettingsState>().having(
          (s) => s.reminderStyle,
          'reminderStyle',
          ReminderStyle.none,
        ),
      ],
    );

    blocTest<UserSettingsBloc, UserSettingsState>(
      'mealCheckinScheduleModeChanged stores the chosen mode',
      build: UserSettingsBloc.new,
      act: (bloc) => bloc.add(
        const UserSettingsEvent.mealCheckinScheduleModeChanged(
          MealCheckinScheduleMode.endOfDay,
        ),
      ),
      expect: () => [
        isA<UserSettingsState>().having(
          (s) => s.mealCheckinScheduleMode,
          'mealCheckinScheduleMode',
          MealCheckinScheduleMode.endOfDay,
        ),
      ],
    );

    group('meal reminders', () {
      blocTest<UserSettingsBloc, UserSettingsState>(
        'mealReminderToggled flips the enabled flag',
        build: UserSettingsBloc.new,
        act: (bloc) => bloc.add(
          const UserSettingsEvent.mealReminderToggled(
            MealOfTheDay.breakfast,
            enabled: false,
          ),
        ),
        expect: () => [
          isA<UserSettingsState>().having(
            (s) => s.mealReminders[MealOfTheDay.breakfast]!.enabled,
            'breakfast enabled',
            isFalse,
          ),
        ],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'mealReminderToggled does nothing when the meal has no reminder',
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(mealReminders: {}),
        act: (bloc) => bloc.add(
          const UserSettingsEvent.mealReminderToggled(
            MealOfTheDay.breakfast,
            enabled: false,
          ),
        ),
        expect: () => <UserSettingsState>[],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'mealReminderTimeChanged updates the time',
        build: UserSettingsBloc.new,
        act: (bloc) => bloc.add(
          const UserSettingsEvent.mealReminderTimeChanged(
            MealOfTheDay.lunch,
            TimeOfDay(hour: 12, minute: 0),
          ),
        ),
        expect: () => [
          isA<UserSettingsState>().having(
            (s) => s.mealReminders[MealOfTheDay.lunch]!.timeOfDay,
            'lunch time',
            const TimeOfDay(hour: 12, minute: 0),
          ),
        ],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'mealReminderTimeChanged does nothing when the meal has no reminder',
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(mealReminders: {}),
        act: (bloc) => bloc.add(
          const UserSettingsEvent.mealReminderTimeChanged(
            MealOfTheDay.lunch,
            TimeOfDay(hour: 12, minute: 0),
          ),
        ),
        expect: () => <UserSettingsState>[],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'endOfDayTimeChanged updates the end-of-day reminder time',
        build: UserSettingsBloc.new,
        act: (bloc) => bloc.add(
          const UserSettingsEvent.endOfDayTimeChanged(
            TimeOfDay(hour: 22, minute: 0),
          ),
        ),
        expect: () => [
          isA<UserSettingsState>().having(
            (s) => s.endOfDayReminder.timeOfDay,
            'end of day time',
            const TimeOfDay(hour: 22, minute: 0),
          ),
        ],
      );
    });

    group('weight settings', () {
      blocTest<UserSettingsBloc, UserSettingsState>(
        'weightCheckinFrequencySelected stores the frequency',
        build: UserSettingsBloc.new,
        act: (bloc) => bloc.add(
          const UserSettingsEvent.weightCheckinFrequencySelected(
            WeightCheckinFrequency.off,
          ),
        ),
        expect: () => [
          isA<UserSettingsState>().having(
            (s) => s.weightCheckinFrequency,
            'weightCheckinFrequency',
            WeightCheckinFrequency.off,
          ),
        ],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'weightTimeOfDaySelected stores the time of day',
        build: UserSettingsBloc.new,
        act: (bloc) => bloc.add(
          const UserSettingsEvent.weightTimeOfDaySelected(
            WeightTimeOfDay.evening,
          ),
        ),
        expect: () => [
          isA<UserSettingsState>().having(
            (s) => s.weightTimeOfDay,
            'weightTimeOfDay',
            WeightTimeOfDay.evening,
          ),
        ],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'weightUnitSelected stores the unit',
        build: UserSettingsBloc.new,
        act: (bloc) => bloc.add(
          const UserSettingsEvent.weightUnitSelected(WeightUnit.kg),
        ),
        expect: () => [
          isA<UserSettingsState>().having(
            (s) => s.weightUnit,
            'weightUnit',
            WeightUnit.kg,
          ),
        ],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'startingWeightChanged stores the weight',
        build: UserSettingsBloc.new,
        act: (bloc) =>
            bloc.add(const UserSettingsEvent.startingWeightChanged(72.5)),
        expect: () => [
          isA<UserSettingsState>().having(
            (s) => s.startingWeight,
            'startingWeight',
            72.5,
          ),
        ],
      );
    });

    blocTest<UserSettingsBloc, UserSettingsState>(
      'themeModeSelected stores the theme mode',
      build: UserSettingsBloc.new,
      act: (bloc) => bloc.add(
        const UserSettingsEvent.themeModeSelected(ThemeMode.dark),
      ),
      expect: () => [
        isA<UserSettingsState>().having(
          (s) => s.themeMode,
          'themeMode',
          ThemeMode.dark,
        ),
      ],
    );

    group('usual meals', () {
      blocTest<UserSettingsBloc, UserSettingsState>(
        'usualMealAdded appends a new usual meal',
        build: UserSettingsBloc.new,
        act: (bloc) => bloc.add(
          const UserSettingsEvent.usualMealAdded(
            MealOfTheDay.breakfast,
            'Eggs',
            Nutrition(calories: 350),
          ),
        ),
        expect: () => [
          isA<UserSettingsState>().having(
            (s) => s.usuals[MealOfTheDay.breakfast],
            'breakfast usuals',
            hasLength(1),
          ),
        ],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'usualMealAdded ignores a blank name',
        build: UserSettingsBloc.new,
        act: (bloc) => bloc.add(
          const UserSettingsEvent.usualMealAdded(
            MealOfTheDay.breakfast,
            '   ',
            Nutrition(),
          ),
        ),
        expect: () => <UserSettingsState>[],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'usualMealAdded ignores a duplicate name regardless of case',
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(
          usuals: {
            MealOfTheDay.breakfast: [UsualMeal(id: 'a', name: 'Eggs')],
          },
        ),
        act: (bloc) => bloc.add(
          const UserSettingsEvent.usualMealAdded(
            MealOfTheDay.breakfast,
            'EGGS',
            Nutrition(calories: 100),
          ),
        ),
        expect: () => <UserSettingsState>[],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'usualMealRemoved drops the matching meal',
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(
          usuals: {
            MealOfTheDay.breakfast: [
              UsualMeal(id: 'a', name: 'Eggs'),
              UsualMeal(id: 'b', name: 'Oats'),
            ],
          },
        ),
        act: (bloc) => bloc.add(
          const UserSettingsEvent.usualMealRemoved(MealOfTheDay.breakfast, 'a'),
        ),
        expect: () => [
          isA<UserSettingsState>().having(
            (s) => s.usuals[MealOfTheDay.breakfast],
            'remaining usuals',
            hasLength(1),
          ),
        ],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'usualMealNutritionChanged updates the matching meal only',
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(
          usuals: {
            MealOfTheDay.breakfast: [
              UsualMeal(id: 'a', name: 'Eggs'),
              UsualMeal(id: 'b', name: 'Oats'),
            ],
          },
        ),
        act: (bloc) => bloc.add(
          const UserSettingsEvent.usualMealNutritionChanged(
            MealOfTheDay.breakfast,
            'b',
            Nutrition(calories: 420),
          ),
        ),
        expect: () => [
          isA<UserSettingsState>().having(
            (s) => s.usuals[MealOfTheDay.breakfast]!.last.nutrition.calories,
            'updated calories',
            420,
          ),
        ],
      );
    });

    test('toJson then fromJson round-trips the state', () {
      final bloc = UserSettingsBloc();
      const state = UserSettingsState(weightUnit: WeightUnit.kg);

      final restored = bloc.fromJson(bloc.toJson(state));

      expect(restored, equals(state));
    });
  });
}
