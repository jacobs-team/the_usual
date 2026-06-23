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
      'calorieGoalChanged stores the goal',
      build: UserSettingsBloc.new,
      act: (bloc) => bloc.add(const UserSettingsEvent.calorieGoalChanged(2200)),
      expect: () => [
        isA<UserSettingsState>().having(
          (s) => s.calorieGoal,
          'calorieGoal',
          2200,
        ),
      ],
    );

    blocTest<UserSettingsBloc, UserSettingsState>(
      'weightGoalChanged stores the goal',
      build: UserSettingsBloc.new,
      act: (bloc) => bloc.add(const UserSettingsEvent.weightGoalChanged(68)),
      expect: () => [
        isA<UserSettingsState>().having(
          (s) => s.weightGoal,
          'weightGoal',
          68.0,
        ),
      ],
    );

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

    blocTest<UserSettingsBloc, UserSettingsState>(
      'expandNutritionByDefaultChanged stores the flag',
      build: UserSettingsBloc.new,
      act: (bloc) => bloc.add(
        const UserSettingsEvent.expandNutritionByDefaultChanged(
          expandNutritionByDefault: true,
        ),
      ),
      expect: () => [
        isA<UserSettingsState>().having(
          (s) => s.expandNutritionByDefault,
          'expandNutritionByDefault',
          isTrue,
        ),
      ],
    );

    blocTest<UserSettingsBloc, UserSettingsState>(
      'skipLoggedMealRemindersChanged stores the flag',
      build: UserSettingsBloc.new,
      act: (bloc) => bloc.add(
        const UserSettingsEvent.skipLoggedMealRemindersChanged(
          skipLoggedMealReminders: true,
        ),
      ),
      expect: () => [
        isA<UserSettingsState>().having(
          (s) => s.skipLoggedMealReminders,
          'skipLoggedMealReminders',
          isTrue,
        ),
      ],
    );

    blocTest<UserSettingsBloc, UserSettingsState>(
      'dayStartTimeChanged stores the time',
      build: UserSettingsBloc.new,
      act: (bloc) => bloc.add(
        const UserSettingsEvent.dayStartTimeChanged(
          TimeOfDay(hour: 4, minute: 30),
        ),
      ),
      expect: () => [
        isA<UserSettingsState>().having(
          (s) => s.dayStartTime,
          'dayStartTime',
          const TimeOfDay(hour: 4, minute: 30),
        ),
      ],
    );

    blocTest<UserSettingsBloc, UserSettingsState>(
      'mealEntryModeChanged stores the mode',
      build: UserSettingsBloc.new,
      act: (bloc) => bloc.add(
        const UserSettingsEvent.mealEntryModeChanged(MealEntryMode.itemized),
      ),
      expect: () => [
        isA<UserSettingsState>().having(
          (s) => s.mealEntryMode,
          'mealEntryMode',
          MealEntryMode.itemized,
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

      blocTest<UserSettingsBloc, UserSettingsState>(
        'usualMealNameChanged renames the matching meal only',
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
          const UserSettingsEvent.usualMealNameChanged(
            MealOfTheDay.breakfast,
            'b',
            'Porridge',
          ),
        ),
        expect: () => [
          isA<UserSettingsState>().having(
            (s) => s.usuals[MealOfTheDay.breakfast]!.last.name,
            'renamed meal',
            'Porridge',
          ),
        ],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'usualMealNameChanged ignores a blank name',
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(
          usuals: {
            MealOfTheDay.breakfast: [UsualMeal(id: 'a', name: 'Eggs')],
          },
        ),
        act: (bloc) => bloc.add(
          const UserSettingsEvent.usualMealNameChanged(
            MealOfTheDay.breakfast,
            'a',
            '   ',
          ),
        ),
        expect: () => <UserSettingsState>[],
      );
    });

    group('workout groups', () {
      blocTest<UserSettingsBloc, UserSettingsState>(
        'workoutGroupAdded appends a new group after the defaults',
        build: UserSettingsBloc.new,
        act: (bloc) =>
            bloc.add(const UserSettingsEvent.workoutGroupAdded('Arms')),
        expect: () => [
          isA<UserSettingsState>()
              .having((s) => s.workoutGroups, 'workoutGroups', hasLength(4))
              .having(
                (s) => s.workoutGroups.last.name,
                'new group name',
                'Arms',
              )
              .having(
                (s) => s.workoutGroups.last.order,
                'new group order',
                3,
              ),
        ],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'workoutGroupAdded ignores a duplicate name (case-insensitive)',
        build: UserSettingsBloc.new,
        act: (bloc) =>
            bloc.add(const UserSettingsEvent.workoutGroupAdded('push')),
        expect: () => <UserSettingsState>[],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'workoutGroupRenamed renames the matching group',
        build: UserSettingsBloc.new,
        act: (bloc) => bloc.add(
          const UserSettingsEvent.workoutGroupRenamed('push', 'Press Day'),
        ),
        expect: () => [
          isA<UserSettingsState>().having(
            (s) => s.workoutGroups.first.name,
            'renamed group',
            'Press Day',
          ),
        ],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'workoutGroupReordered reorders and reassigns order indices',
        build: UserSettingsBloc.new,
        act: (bloc) => bloc.add(
          const UserSettingsEvent.workoutGroupReordered([
            'legs',
            'push',
            'pull',
          ]),
        ),
        expect: () => [
          isA<UserSettingsState>()
              .having(
                (s) => s.workoutGroups.map((g) => g.id).toList(),
                'order of ids',
                ['legs', 'push', 'pull'],
              )
              .having(
                (s) => s.workoutGroups.map((g) => g.order).toList(),
                'reassigned orders',
                [0, 1, 2],
              ),
        ],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'workoutGroupRemoved removes an empty group',
        build: UserSettingsBloc.new,
        act: (bloc) =>
            bloc.add(const UserSettingsEvent.workoutGroupRemoved('legs')),
        expect: () => [
          isA<UserSettingsState>().having(
            (s) => s.workoutGroups.map((g) => g.id).toList(),
            'remaining ids',
            ['push', 'pull'],
          ),
        ],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'workoutGroupRemoved is a no-op when the group still has usuals',
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(
          usualWorkouts: {
            'legs': [UsualWorkout(id: 'u1', name: 'Squat')],
          },
        ),
        act: (bloc) =>
            bloc.add(const UserSettingsEvent.workoutGroupRemoved('legs')),
        expect: () => <UserSettingsState>[],
      );
    });

    group('usual workouts', () {
      blocTest<UserSettingsBloc, UserSettingsState>(
        'usualWorkoutAdded adds a usual under its group',
        build: UserSettingsBloc.new,
        act: (bloc) => bloc.add(
          const UserSettingsEvent.usualWorkoutAdded('push', 'Bench Press', [
            WorkoutSet(weight: 135, reps: 8),
          ]),
        ),
        expect: () => [
          isA<UserSettingsState>()
              .having(
                (s) => s.usualWorkouts['push'], 'push usuals', hasLength(1),
              )
              .having(
                (s) => s.usualWorkouts['push']!.single.name,
                'usual name',
                'Bench Press',
              ),
        ],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'usualWorkoutAdded ignores a duplicate name within the group',
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(
          usualWorkouts: {
            'push': [UsualWorkout(id: 'u1', name: 'Bench Press')],
          },
        ),
        act: (bloc) => bloc.add(
          const UserSettingsEvent.usualWorkoutAdded('push', 'bench press', []),
        ),
        expect: () => <UserSettingsState>[],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'usualWorkoutRenamed renames the matching usual',
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(
          usualWorkouts: {
            'push': [UsualWorkout(id: 'u1', name: 'Bench Press')],
          },
        ),
        act: (bloc) => bloc.add(
          const UserSettingsEvent.usualWorkoutRenamed(
            'push',
            'u1',
            'Incline Press',
          ),
        ),
        expect: () => [
          isA<UserSettingsState>().having(
            (s) => s.usualWorkouts['push']!.single.name,
            'renamed usual',
            'Incline Press',
          ),
        ],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        "usualWorkoutSetsChanged replaces the usual's sets",
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(
          usualWorkouts: {
            'push': [
              UsualWorkout(
                id: 'u1',
                name: 'Bench Press',
                sets: [WorkoutSet(weight: 135, reps: 8)],
              ),
            ],
          },
        ),
        act: (bloc) => bloc.add(
          const UserSettingsEvent.usualWorkoutSetsChanged('push', 'u1', [
            WorkoutSet(weight: 155, reps: 5),
          ]),
        ),
        expect: () => [
          isA<UserSettingsState>().having(
            (s) => s.usualWorkouts['push']!.single.sets.single.weight,
            'updated set weight',
            155,
          ),
        ],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'usualWorkoutRemoved drops the matching usual',
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(
          usualWorkouts: {
            'push': [
              UsualWorkout(id: 'u1', name: 'Bench Press'),
              UsualWorkout(id: 'u2', name: 'Overhead Press'),
            ],
          },
        ),
        act: (bloc) =>
            bloc.add(const UserSettingsEvent.usualWorkoutRemoved('push', 'u1')),
        expect: () => [
          isA<UserSettingsState>().having(
            (s) => s.usualWorkouts['push']!.single.id,
            'remaining usual id',
            'u2',
          ),
        ],
      );
    });

    group('workout reminders', () {
      blocTest<UserSettingsBloc, UserSettingsState>(
        'workoutReminderToggled updates the enabled flag',
        build: UserSettingsBloc.new,
        act: (bloc) => bloc.add(
          const UserSettingsEvent.workoutReminderToggled(enabled: true),
        ),
        expect: () => [
          isA<UserSettingsState>().having(
            (s) => s.workoutReminder.enabled,
            'workoutReminder.enabled',
            isTrue,
          ),
        ],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'workoutReminderDayToggled adds a day when enabled is true',
        build: UserSettingsBloc.new,
        act: (bloc) => bloc.add(
          const UserSettingsEvent.workoutReminderDayToggled(3, enabled: true),
        ),
        expect: () => [
          isA<UserSettingsState>().having(
            (s) => s.workoutReminder.daysOfWeek,
            'workoutReminder.daysOfWeek',
            contains(3),
          ),
        ],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'workoutReminderDayToggled removes a day when enabled is false',
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(
          workoutReminder: WorkoutReminder(
            daysOfWeek: {1, 3, 5},
            timeOfDay: TimeOfDay(hour: 18, minute: 0),
          ),
        ),
        act: (bloc) => bloc.add(
          const UserSettingsEvent.workoutReminderDayToggled(3, enabled: false),
        ),
        expect: () => [
          isA<UserSettingsState>().having(
            (s) => s.workoutReminder.daysOfWeek,
            'workoutReminder.daysOfWeek',
            isNot(contains(3)),
          ),
        ],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'workoutReminderTimeChanged updates the time',
        build: UserSettingsBloc.new,
        act: (bloc) => bloc.add(
          const UserSettingsEvent.workoutReminderTimeChanged(
            TimeOfDay(hour: 7, minute: 30),
          ),
        ),
        expect: () => [
          isA<UserSettingsState>().having(
            (s) => s.workoutReminder.timeOfDay,
            'workoutReminder.timeOfDay',
            const TimeOfDay(hour: 7, minute: 30),
          ),
        ],
      );
    });

    blocTest<UserSettingsBloc, UserSettingsState>(
      'workoutWeightUnitSelected stores the chosen unit',
      build: UserSettingsBloc.new,
      act: (bloc) => bloc.add(
        const UserSettingsEvent.workoutWeightUnitSelected(WeightUnit.kg),
      ),
      expect: () => [
        isA<UserSettingsState>().having(
          (s) => s.workoutWeightUnit,
          'workoutWeightUnit',
          WeightUnit.kg,
        ),
      ],
    );

    test('toJson then fromJson round-trips the state', () {
      final bloc = UserSettingsBloc();
      const state = UserSettingsState(weightUnit: WeightUnit.kg);

      final restored = bloc.fromJson(bloc.toJson(state));

      expect(restored, equals(state));
    });

    test('toJson then fromJson round-trips a populated usuals map', () {
      final bloc = UserSettingsBloc();
      const state = UserSettingsState(
        usuals: {
          MealOfTheDay.breakfast: [
            UsualMeal(
              id: 'a',
              name: 'Eggs',
              nutrition: Nutrition(calories: 90),
            ),
          ],
          MealOfTheDay.lunch: [
            UsualMeal(id: 'b', name: 'Salad'),
          ],
        },
      );

      final restored = bloc.fromJson(bloc.toJson(state));

      expect(restored, equals(state));
    });
  });
}
