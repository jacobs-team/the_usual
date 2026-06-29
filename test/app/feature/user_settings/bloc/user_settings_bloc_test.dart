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
      'calorieGoalChanged keeps an entry effective on a different day',
      build: UserSettingsBloc.new,
      seed: () => UserSettingsState(
        calorieGoalHistory: [
          CalorieGoalEntry(
            effectiveFrom: DateTime(2020),
            calories: 1500,
          ),
        ],
      ),
      act: (bloc) => bloc.add(const UserSettingsEvent.calorieGoalChanged(2200)),
      expect: () => [
        isA<UserSettingsState>()
            .having(
              (s) => s.calorieGoalHistory,
              'calorieGoalHistory',
              hasLength(2),
            )
            .having((s) => s.calorieGoal, 'calorieGoal', 2200),
      ],
    );

    blocTest<UserSettingsBloc, UserSettingsState>(
      'weightGoalChanged keeps an entry effective on a different day',
      build: UserSettingsBloc.new,
      seed: () => UserSettingsState(
        weightGoalHistory: [
          WeightGoalEntry(
            effectiveFrom: DateTime(2020),
            weightUnit: WeightUnit.lb,
            weight: 80,
          ),
        ],
      ),
      act: (bloc) => bloc.add(const UserSettingsEvent.weightGoalChanged(68)),
      expect: () => [
        isA<UserSettingsState>()
            .having(
              (s) => s.weightGoalHistory,
              'weightGoalHistory',
              hasLength(2),
            )
            .having((s) => s.weightGoal, 'weightGoal', 68.0),
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

      blocTest<UserSettingsBloc, UserSettingsState>(
        'usualMealAdded stores components on the usual meal',
        build: UserSettingsBloc.new,
        act: (bloc) => bloc.add(
          const UserSettingsEvent.usualMealAdded(
            MealOfTheDay.lunch,
            'Chicken & rice bowl',
            Nutrition(calories: 293),
            components: [
              MealComponent(name: 'Chicken, 1 oz', quantity: 4),
            ],
          ),
        ),
        verify: (bloc) {
          final usualMeals = bloc.state.usuals[MealOfTheDay.lunch]!;
          expect(usualMeals.single.components, hasLength(1));
        },
      );

      test('saveAsUsualMeal stores components and returns the id', () async {
        final bloc = UserSettingsBloc();
        final id = bloc.saveAsUsualMeal(
          MealOfTheDay.lunch,
          'Chicken & rice bowl',
          const Nutrition(calories: 293),
          components: const [MealComponent(name: 'Chicken, 1 oz', quantity: 4)],
        );
        await bloc.stream.first;
        final usualMeal = bloc.state.usuals[MealOfTheDay.lunch]!
            .firstWhere((usualMeal) => usualMeal.id == id);
        expect(usualMeal.components, hasLength(1));
      });
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
        'workoutGroupReordered appends groups missing from the ordered ids',
        build: UserSettingsBloc.new,
        act: (bloc) => bloc.add(
          const UserSettingsEvent.workoutGroupReordered(['legs', 'push']),
        ),
        expect: () => [
          isA<UserSettingsState>()
              .having(
                (s) => s.workoutGroups.map((g) => g.id).toList(),
                'order of ids with the unnamed group last',
                ['legs', 'push', 'pull'],
              )
              .having(
                (s) => s.workoutGroups.last.order,
                'unnamed group order',
                2,
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
                (s) => s.usualWorkouts['push'],
                'push usuals',
                hasLength(1),
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
        'usualWorkoutRenamed leaves the other usuals untouched',
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(
          usualWorkouts: {
            'push': [
              UsualWorkout(id: 'u1', name: 'Bench Press'),
              UsualWorkout(id: 'u2', name: 'Overhead Press'),
            ],
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
            (s) => s.usualWorkouts['push']!.map((w) => w.name).toList(),
            'names',
            ['Incline Press', 'Overhead Press'],
          ),
        ],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'usualWorkoutSetsChanged leaves the other usuals untouched',
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(
          usualWorkouts: {
            'push': [
              UsualWorkout(
                id: 'u1',
                name: 'Bench Press',
                sets: [WorkoutSet(weight: 135, reps: 8)],
              ),
              UsualWorkout(id: 'u2', name: 'Overhead Press'),
            ],
          },
        ),
        act: (bloc) => bloc.add(
          const UserSettingsEvent.usualWorkoutSetsChanged('push', 'u1', [
            WorkoutSet(weight: 155, reps: 5),
          ]),
        ),
        expect: () => [
          isA<UserSettingsState>()
              .having(
                (s) => s.usualWorkouts['push']!.first.sets.single.weight,
                'updated set weight',
                155,
              )
              .having(
                (s) => s.usualWorkouts['push']!.last.sets,
                'untouched usual sets',
                isEmpty,
              ),
        ],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        "usualWorkoutDurationChanged updates the matching usual's duration",
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(
          usualWorkouts: {
            'push': [
              UsualWorkout(id: 'u1', name: 'Plank'),
              UsualWorkout(id: 'u2', name: 'Run'),
            ],
          },
        ),
        act: (bloc) => bloc.add(
          const UserSettingsEvent.usualWorkoutDurationChanged(
            'push',
            'u2',
            Duration(minutes: 30),
          ),
        ),
        expect: () => [
          isA<UserSettingsState>()
              .having(
                (s) => s.usualWorkouts['push']!.last.duration,
                'updated duration',
                const Duration(minutes: 30),
              )
              .having(
                (s) => s.usualWorkouts['push']!.first.duration,
                'untouched usual duration',
                isNull,
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

    blocTest<UserSettingsBloc, UserSettingsState>(
      'saveMealAsUsualChanged stores the flag',
      build: UserSettingsBloc.new,
      act: (bloc) => bloc.add(
        const UserSettingsEvent.saveMealAsUsualChanged(value: false),
      ),
      expect: () => [
        isA<UserSettingsState>().having(
          (s) => s.saveMealAsUsual,
          'saveMealAsUsual',
          isFalse,
        ),
      ],
    );

    blocTest<UserSettingsBloc, UserSettingsState>(
      'saveWorkoutAsUsualChanged stores the flag',
      build: UserSettingsBloc.new,
      act: (bloc) => bloc.add(
        const UserSettingsEvent.saveWorkoutAsUsualChanged(value: true),
      ),
      expect: () => [
        isA<UserSettingsState>().having(
          (s) => s.saveWorkoutAsUsual,
          'saveWorkoutAsUsual',
          isTrue,
        ),
      ],
    );

    group('saveAsUsualMeal', () {
      test('returns the existing id when a usual with that name exists', () {
        final bloc = UserSettingsBloc()
          ..emit(
            const UserSettingsState(
              usuals: {
                MealOfTheDay.lunch: [UsualMeal(id: 'existing', name: 'Salad')],
              },
            ),
          );

        final id = bloc.saveAsUsualMeal(
          MealOfTheDay.lunch,
          'salad',
          const Nutrition(calories: 200),
        );

        expect(id, equals('existing'));
        expect(bloc.state.usuals[MealOfTheDay.lunch], hasLength(1));
      });

      test('adds a new usual with a generated id when none exists', () async {
        final bloc = UserSettingsBloc();

        final id = bloc.saveAsUsualMeal(
          MealOfTheDay.dinner,
          '  Tacos  ',
          const Nutrition(calories: 600),
        );

        await bloc.stream.first;

        expect(id, isNotEmpty);
        final dinnerUsuals = bloc.state.usuals[MealOfTheDay.dinner];
        expect(dinnerUsuals, hasLength(1));
        expect(dinnerUsuals!.single.id, equals(id));
        expect(dinnerUsuals.single.name, equals('Tacos'));
      });
    });

    group('usual food propagation', () {
      blocTest<UserSettingsBloc, UserSettingsState>(
        'usualFoodPropagatedToMeals updates matching components and '
        'recomputes meal totals',
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(
          usuals: {
            MealOfTheDay.lunch: [
              UsualMeal(
                id: 'm1',
                name: 'Bowl',
                nutrition: Nutrition(calories: 293),
                components: [
                  MealComponent(
                    name: 'Chicken, 1 oz',
                    nutrition: Nutrition(calories: 22, protein: 5),
                    quantity: 4,
                    usualFoodId: 'f1',
                  ),
                  MealComponent(
                    name: 'Rice, 100 g',
                    nutrition: Nutrition(calories: 205, carbs: 45),
                    usualFoodId: 'f2',
                  ),
                ],
              ),
            ],
          },
        ),
        act: (bloc) => bloc.add(
          const UserSettingsEvent.usualFoodPropagatedToMeals(
            'f1',
            Nutrition(calories: 30, protein: 6),
          ),
        ),
        verify: (bloc) {
          final usualMeal = bloc.state.usuals[MealOfTheDay.lunch]!.single;
          expect(usualMeal.components.first.nutrition.calories, equals(30));
          // recomputed total: 30*4 + 205 = 325 cal, 6*4 = 24 protein, 45 carbs.
          expect(usualMeal.nutrition.calories, equals(325));
          expect(usualMeal.nutrition.protein, equals(24));
          expect(usualMeal.nutrition.carbs, equals(45));
        },
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'usualFoodPropagatedToMeals leaves meals without the food unchanged',
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(
          usuals: {
            MealOfTheDay.lunch: [
              UsualMeal(
                id: 'm1',
                name: 'Bowl',
                nutrition: Nutrition(calories: 293),
                components: [
                  MealComponent(
                    name: 'Chicken, 1 oz',
                    nutrition: Nutrition(calories: 22, protein: 5),
                    quantity: 4,
                    usualFoodId: 'f1',
                  ),
                ],
              ),
              UsualMeal(
                id: 'm2',
                name: 'Salad',
                nutrition: Nutrition(calories: 100),
                components: [
                  MealComponent(
                    name: 'Lettuce',
                    nutrition: Nutrition(calories: 100),
                  ),
                ],
              ),
            ],
          },
        ),
        act: (bloc) => bloc.add(
          const UserSettingsEvent.usualFoodPropagatedToMeals(
            'f1',
            Nutrition(calories: 30, protein: 6),
          ),
        ),
        verify: (bloc) {
          final usualMeals = bloc.state.usuals[MealOfTheDay.lunch]!;
          final salad = usualMeals.firstWhere(
            (usualMeal) => usualMeal.id == 'm2',
          );
          expect(salad.nutrition.calories, equals(100));
          expect(salad.components.single.name, equals('Lettuce'));
        },
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'usualMealComponentsChanged sets components and nutrition',
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(
          usuals: {MealOfTheDay.lunch: [UsualMeal(id: 'm1', name: 'Bowl')]},
        ),
        act: (bloc) => bloc.add(
          const UserSettingsEvent.usualMealComponentsChanged(
            MealOfTheDay.lunch,
            'm1',
            [
              MealComponent(
                name: 'Chicken, 1 oz',
                nutrition: Nutrition(calories: 22),
                quantity: 3,
                usualFoodId: 'f1',
              ),
            ],
            Nutrition(calories: 66),
          ),
        ),
        verify: (bloc) {
          final usualMeal = bloc.state.usuals[MealOfTheDay.lunch]!.single;
          expect(usualMeal.components, hasLength(1));
          expect(usualMeal.nutrition.calories, equals(66));
        },
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'usualMealComponentsChanged is a no-op when the id does not match',
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(
          usuals: {
            MealOfTheDay.lunch: [
              UsualMeal(
                id: 'm1',
                name: 'Bowl',
                nutrition: Nutrition(calories: 200),
              ),
            ],
          },
        ),
        act: (bloc) => bloc.add(
          const UserSettingsEvent.usualMealComponentsChanged(
            MealOfTheDay.lunch,
            'zzz',
            [
              MealComponent(
                name: 'Chicken, 1 oz',
                nutrition: Nutrition(calories: 22),
              ),
            ],
            Nutrition(calories: 22),
          ),
        ),
        verify: (bloc) {
          final usualMeal = bloc.state.usuals[MealOfTheDay.lunch]!.single;
          expect(usualMeal.components, isEmpty);
          expect(usualMeal.nutrition.calories, equals(200));
        },
      );
    });

    group('usual foods', () {
      blocTest<UserSettingsBloc, UserSettingsState>(
        'usualFoodAdded adds a food with a generated id',
        build: UserSettingsBloc.new,
        act: (bloc) => bloc.add(
          const UserSettingsEvent.usualFoodAdded(
            'Chicken, 1 oz', Nutrition(calories: 22, protein: 5),
          ),
        ),
        verify: (bloc) {
          expect(bloc.state.usualFoods, hasLength(1));
          expect(bloc.state.usualFoods.single.name, equals('Chicken, 1 oz'));
        },
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'usualFoodNameChanged and usualFoodNutritionChanged edit in place',
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(
          usualFoods: [
            UsualFood(
              id: 'f1',
              name: 'Chicken',
              nutrition: Nutrition(calories: 22),
            ),
          ],
        ),
        act: (bloc) => bloc
          ..add(
            const UserSettingsEvent.usualFoodNameChanged('f1', 'Chicken, 1 oz'),
          )
          ..add(
            const UserSettingsEvent.usualFoodNutritionChanged(
              'f1',
              Nutrition(calories: 25),
            ),
          ),
        verify: (bloc) {
          expect(bloc.state.usualFoods.single.name, equals('Chicken, 1 oz'));
          expect(bloc.state.usualFoods.single.nutrition.calories, equals(25));
        },
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'usualFoodNutritionChanged is a no-op when the id does not match',
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(
          usualFoods: [
            UsualFood(
              id: 'f1',
              name: 'Chicken',
              nutrition: Nutrition(calories: 22),
            ),
          ],
        ),
        act: (bloc) => bloc.add(
          const UserSettingsEvent.usualFoodNutritionChanged(
            'zzz',
            Nutrition(calories: 999),
          ),
        ),
        verify: (bloc) {
          expect(bloc.state.usualFoods.single.nutrition.calories, equals(22));
        },
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'usualFoodAdded is a no-op when a food with the same name already '
        'exists (case-insensitive)',
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(
          usualFoods: [
            UsualFood(
              id: 'f1',
              name: 'Chicken, 1 oz',
              nutrition: Nutrition(calories: 22),
            ),
          ],
        ),
        act: (bloc) => bloc.add(
          const UserSettingsEvent.usualFoodAdded(
            'chicken, 1 oz',
            Nutrition(calories: 50),
          ),
        ),
        verify: (bloc) {
          expect(bloc.state.usualFoods, hasLength(1));
        },
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'usualFoodNameChanged is a no-op when the id does not match',
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(
          usualFoods: [
            UsualFood(id: 'f1', name: 'Chicken'),
            UsualFood(id: 'f2', name: 'Rice'),
          ],
        ),
        act: (bloc) => bloc.add(
          const UserSettingsEvent.usualFoodNameChanged('f1', 'Renamed'),
        ),
        verify: (bloc) {
          expect(bloc.state.usualFoods.last.name, equals('Rice'));
        },
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'usualFoodNameChanged is a no-op when the name is blank',
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(
          usualFoods: [UsualFood(id: 'f1', name: 'Chicken')],
        ),
        act: (bloc) => bloc.add(
          const UserSettingsEvent.usualFoodNameChanged('f1', '   '),
        ),
        expect: () => <UserSettingsState>[],
      );

      blocTest<UserSettingsBloc, UserSettingsState>(
        'usualFoodRemoved deletes by id',
        build: UserSettingsBloc.new,
        seed: () => const UserSettingsState(
          usualFoods: [UsualFood(id: 'f1', name: 'Chicken')],
        ),
        act: (bloc) => bloc.add(const UserSettingsEvent.usualFoodRemoved('f1')),
        verify: (bloc) => expect(bloc.state.usualFoods, isEmpty),
      );

      test('saveAsUsualFood returns the existing id when a food with that '
          'name exists', () {
        final bloc = UserSettingsBloc()
          ..emit(
            const UserSettingsState(
              usualFoods: [
                UsualFood(
                  id: 'f1',
                  name: 'Chicken, 1 oz',
                  nutrition: Nutrition(calories: 22),
                ),
              ],
            ),
          );

        final id = bloc.saveAsUsualFood(
          'chicken, 1 oz',
          const Nutrition(calories: 99),
        );

        expect(id, equals('f1'));
        expect(bloc.state.usualFoods, hasLength(1));
        expect(bloc.state.usualFoods.single.nutrition.calories, equals(22));
      });

      test('saveAsUsualFood adds a new food with a generated id when none '
          'exists', () async {
        final bloc = UserSettingsBloc();

        final id = bloc.saveAsUsualFood(
          '  Rice, 100 g  ',
          const Nutrition(calories: 205),
        );

        await bloc.stream.first;

        expect(id, isNotEmpty);
        expect(bloc.state.usualFoods, hasLength(1));
        expect(bloc.state.usualFoods.single.id, equals(id));
        expect(bloc.state.usualFoods.single.name, equals('Rice, 100 g'));
      });
    });

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
