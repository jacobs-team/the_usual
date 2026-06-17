import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(OnboardingBloc, () {
    setUp(initHydratedStorage);

    test('initial state is the default OnboardingState', () {
      expect(OnboardingBloc().state, equals(const OnboardingState()));
    });

    group('step navigation', () {
      blocTest<OnboardingBloc, OnboardingState>(
        'continuePressed advances the active step index',
        build: OnboardingBloc.new,
        act: (bloc) => bloc.add(const OnboardingEvent.continuePressed()),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.activeStepIndex,
            'activeStepIndex',
            1,
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'backPressed decrements the active step index',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(activeStepIndex: 2),
        act: (bloc) => bloc.add(const OnboardingEvent.backPressed()),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.activeStepIndex,
            'activeStepIndex',
            1,
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'resetPressed returns to the default state',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(activeStepIndex: 3),
        act: (bloc) => bloc.add(const OnboardingEvent.resetPressed()),
        expect: () => [const OnboardingState()],
      );
    });

    group('skipPressed', () {
      blocTest<OnboardingBloc, OnboardingState>(
        'on reminderStyle falls back to onAppOpen and advances',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(activeStepIndex: 2),
        act: (bloc) => bloc.add(const OnboardingEvent.skipPressed()),
        expect: () => [
          isA<OnboardingState>()
              .having(
                (s) => s.settings.reminderStyle,
                'reminderStyle',
                ReminderStyle.onAppOpen,
              )
              .having((s) => s.activeStepIndex, 'activeStepIndex', 3),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'on weightTracking turns weight check-ins off and clears '
        'starting weight',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(
          activeStepIndex: 4,
          settings: UserSettingsState(startingWeight: 165),
        ),
        act: (bloc) => bloc.add(const OnboardingEvent.skipPressed()),
        expect: () => [
          isA<OnboardingState>()
              .having(
                (s) => s.settings.weightCheckinFrequency,
                'weightCheckinFrequency',
                WeightCheckinFrequency.off,
              )
              .having(
                (s) => s.settings.startingWeight,
                'startingWeight',
                isNull,
              )
              .having((s) => s.activeStepIndex, 'activeStepIndex', 5),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'on any other step just advances',
        build: OnboardingBloc.new,
        act: (bloc) => bloc.add(const OnboardingEvent.skipPressed()),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.activeStepIndex,
            'activeStepIndex',
            1,
          ),
        ],
      );
    });

    group('usual meals', () {
      blocTest<OnboardingBloc, OnboardingState>(
        'usualMealAdded appends a new usual meal',
        build: OnboardingBloc.new,
        act: (bloc) => bloc.add(
          const OnboardingEvent.usualMealAdded(
            MealOfTheDay.breakfast,
            'Eggs',
            Nutrition(calories: 350),
          ),
        ),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.settings.usuals[MealOfTheDay.breakfast],
            'breakfast usuals',
            hasLength(1),
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'usualMealAdded ignores a blank name',
        build: OnboardingBloc.new,
        act: (bloc) => bloc.add(
          const OnboardingEvent.usualMealAdded(
            MealOfTheDay.breakfast,
            '  ',
            Nutrition(),
          ),
        ),
        expect: () => <OnboardingState>[],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'usualMealAdded ignores a duplicate name regardless of case',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(
          settings: UserSettingsState(
            usuals: {
              MealOfTheDay.breakfast: [UsualMeal(id: 'a', name: 'Eggs')],
            },
          ),
        ),
        act: (bloc) => bloc.add(
          const OnboardingEvent.usualMealAdded(
            MealOfTheDay.breakfast,
            'eggs',
            Nutrition(calories: 100),
          ),
        ),
        expect: () => <OnboardingState>[],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'usualMealRemoved drops the meal and any first-log selection of it',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(
          firstLogSelectedIds: ['a'],
          settings: UserSettingsState(
            usuals: {
              MealOfTheDay.breakfast: [
                UsualMeal(id: 'a', name: 'Eggs'),
                UsualMeal(id: 'b', name: 'Oats'),
              ],
            },
          ),
        ),
        act: (bloc) => bloc.add(
          const OnboardingEvent.usualMealRemoved(MealOfTheDay.breakfast, 'a'),
        ),
        expect: () => [
          isA<OnboardingState>()
              .having(
                (s) => s.settings.usuals[MealOfTheDay.breakfast],
                'remaining usuals',
                hasLength(1),
              )
              .having(
                (s) => s.firstLogSelectedIds,
                'firstLogSelectedIds',
                isEmpty,
              ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'usualMealNutritionChanged updates the matching meal only',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(
          settings: UserSettingsState(
            usuals: {
              MealOfTheDay.breakfast: [
                UsualMeal(id: 'a', name: 'Eggs'),
                UsualMeal(id: 'b', name: 'Oats'),
              ],
            },
          ),
        ),
        act: (bloc) => bloc.add(
          const OnboardingEvent.usualMealNutritionChanged(
            MealOfTheDay.breakfast,
            'a',
            Nutrition(calories: 400),
          ),
        ),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s
                .settings
                .usuals[MealOfTheDay.breakfast]!
                .first
                .nutrition
                .calories,
            'updated calories',
            400,
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'usualMealNameChanged updates the matching meal only',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(
          settings: UserSettingsState(
            usuals: {
              MealOfTheDay.breakfast: [
                UsualMeal(id: 'a', name: 'Eggs'),
                UsualMeal(id: 'b', name: 'Oats'),
              ],
            },
          ),
        ),
        act: (bloc) => bloc.add(
          const OnboardingEvent.usualMealNameChanged(
            MealOfTheDay.breakfast,
            'a',
            'Scrambled eggs',
          ),
        ),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.settings.usuals[MealOfTheDay.breakfast]!.first.name,
            'updated name',
            'Scrambled eggs',
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'usualMealNameChanged ignores a blank name',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(
          settings: UserSettingsState(
            usuals: {
              MealOfTheDay.breakfast: [UsualMeal(id: 'a', name: 'Eggs')],
            },
          ),
        ),
        act: (bloc) => bloc.add(
          const OnboardingEvent.usualMealNameChanged(
            MealOfTheDay.breakfast,
            'a',
            '   ',
          ),
        ),
        expect: () => <OnboardingState>[],
      );
    });

    group('reminder skip', () {
      blocTest<OnboardingBloc, OnboardingState>(
        'skipLoggedMealRemindersChanged stores the flag',
        build: OnboardingBloc.new,
        act: (bloc) => bloc.add(
          const OnboardingEvent.skipLoggedMealRemindersChanged(
            skipLoggedMealReminders: true,
          ),
        ),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.settings.skipLoggedMealReminders,
            'skipLoggedMealReminders',
            isTrue,
          ),
        ],
      );
    });

    group('goals', () {
      blocTest<OnboardingBloc, OnboardingState>(
        'calorieGoalChanged stores the calorie goal',
        build: OnboardingBloc.new,
        act: (bloc) => bloc.add(const OnboardingEvent.calorieGoalChanged(2200)),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.settings.calorieGoal,
            'calorieGoal',
            2200,
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'weightGoalChanged stores the weight goal',
        build: OnboardingBloc.new,
        act: (bloc) => bloc.add(const OnboardingEvent.weightGoalChanged(150.5)),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.settings.weightGoal,
            'weightGoal',
            150.5,
          ),
        ],
      );
    });

    group('reminder settings', () {
      blocTest<OnboardingBloc, OnboardingState>(
        'reminderStyleSelected stores the chosen style',
        build: OnboardingBloc.new,
        act: (bloc) => bloc.add(
          const OnboardingEvent.reminderStyleSelected(ReminderStyle.none),
        ),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.settings.reminderStyle,
            'reminderStyle',
            ReminderStyle.none,
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'mealCheckinScheduleModeChanged stores the chosen mode',
        build: OnboardingBloc.new,
        act: (bloc) => bloc.add(
          const OnboardingEvent.mealCheckinScheduleModeChanged(
            MealCheckinScheduleMode.endOfDay,
          ),
        ),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.settings.mealCheckinScheduleMode,
            'mealCheckinScheduleMode',
            MealCheckinScheduleMode.endOfDay,
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'mealReminderToggled flips the enabled flag for the meal',
        build: OnboardingBloc.new,
        act: (bloc) => bloc.add(
          const OnboardingEvent.mealReminderToggled(
            MealOfTheDay.breakfast,
            enabled: false,
          ),
        ),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.settings.mealReminders[MealOfTheDay.breakfast]!.enabled,
            'breakfast enabled',
            isFalse,
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'mealReminderToggled does nothing when the meal has no reminder',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(
          settings: UserSettingsState(mealReminders: {}),
        ),
        act: (bloc) => bloc.add(
          const OnboardingEvent.mealReminderToggled(
            MealOfTheDay.breakfast,
            enabled: false,
          ),
        ),
        expect: () => <OnboardingState>[],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'mealReminderTimeChanged updates the time for the meal',
        build: OnboardingBloc.new,
        act: (bloc) => bloc.add(
          const OnboardingEvent.mealReminderTimeChanged(
            MealOfTheDay.lunch,
            TimeOfDay(hour: 12, minute: 30),
          ),
        ),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.settings.mealReminders[MealOfTheDay.lunch]!.timeOfDay,
            'lunch time',
            const TimeOfDay(hour: 12, minute: 30),
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'mealReminderTimeChanged does nothing when the meal has no reminder',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(
          settings: UserSettingsState(mealReminders: {}),
        ),
        act: (bloc) => bloc.add(
          const OnboardingEvent.mealReminderTimeChanged(
            MealOfTheDay.lunch,
            TimeOfDay(hour: 12, minute: 30),
          ),
        ),
        expect: () => <OnboardingState>[],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'endOfDayTimeChanged updates the end-of-day reminder time',
        build: OnboardingBloc.new,
        act: (bloc) => bloc.add(
          const OnboardingEvent.endOfDayTimeChanged(
            TimeOfDay(hour: 21, minute: 15),
          ),
        ),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.settings.endOfDayReminder.timeOfDay,
            'end of day time',
            const TimeOfDay(hour: 21, minute: 15),
          ),
        ],
      );
    });

    group('weight settings', () {
      blocTest<OnboardingBloc, OnboardingState>(
        'weightCheckinFrequencySelected stores the frequency',
        build: OnboardingBloc.new,
        act: (bloc) => bloc.add(
          const OnboardingEvent.weightCheckinFrequencySelected(
            WeightCheckinFrequency.weekly,
          ),
        ),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.settings.weightCheckinFrequency,
            'weightCheckinFrequency',
            WeightCheckinFrequency.weekly,
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'weightTimeOfDaySelected stores the time of day',
        build: OnboardingBloc.new,
        act: (bloc) => bloc.add(
          const OnboardingEvent.weightTimeOfDaySelected(WeightTimeOfDay.night),
        ),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.settings.weightTimeOfDay,
            'weightTimeOfDay',
            WeightTimeOfDay.night,
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'weightUnitSelected stores the unit',
        build: OnboardingBloc.new,
        act: (bloc) => bloc.add(
          const OnboardingEvent.weightUnitSelected(WeightUnit.kg),
        ),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.settings.weightUnit,
            'weightUnit',
            WeightUnit.kg,
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'startingWeightChanged stores the weight',
        build: OnboardingBloc.new,
        act: (bloc) =>
            bloc.add(const OnboardingEvent.startingWeightChanged(180.5)),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.settings.startingWeight,
            'startingWeight',
            180.5,
          ),
        ],
      );
    });

    group('first log', () {
      blocTest<OnboardingBloc, OnboardingState>(
        'firstLogItemToggled selects an unselected item',
        build: OnboardingBloc.new,
        act: (bloc) => bloc.add(const OnboardingEvent.firstLogItemToggled('a')),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.firstLogSelectedIds,
            'firstLogSelectedIds',
            ['a'],
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'firstLogItemToggled deselects an already selected item',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(firstLogSelectedIds: ['a']),
        act: (bloc) => bloc.add(const OnboardingEvent.firstLogItemToggled('a')),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.firstLogSelectedIds,
            'firstLogSelectedIds',
            isEmpty,
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'firstLogItemQuantityChanged stores the rounded quantity for the item',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(firstLogSelectedIds: ['a']),
        act: (bloc) => bloc.add(
          const OnboardingEvent.firstLogItemQuantityChanged('a', 2.5),
        ),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.firstLogQuantities['a'],
            'quantity for a',
            2.5,
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'somethingElseLogged adds a usual and selects it',
        build: OnboardingBloc.new,
        act: (bloc) => bloc.add(
          const OnboardingEvent.somethingElseLogged(
            MealOfTheDay.dinner,
            'Tacos',
            nutrition: Nutrition(calories: 620),
          ),
        ),
        expect: () => [
          isA<OnboardingState>()
              .having(
                (s) => s.settings.usuals[MealOfTheDay.dinner],
                'dinner usuals',
                hasLength(1),
              )
              .having(
                (s) => s.firstLogSelectedIds,
                'firstLogSelectedIds',
                hasLength(1),
              ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'somethingElseLogged stores the rounded quantity for the new usual',
        build: OnboardingBloc.new,
        act: (bloc) => bloc.add(
          const OnboardingEvent.somethingElseLogged(
            MealOfTheDay.dinner,
            'Tacos',
            quantity: 3,
          ),
        ),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.firstLogQuantities.values,
            'stored quantities',
            contains(3.0),
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'somethingElseLogged ignores a blank name',
        build: OnboardingBloc.new,
        act: (bloc) => bloc.add(
          const OnboardingEvent.somethingElseLogged(MealOfTheDay.dinner, '   '),
        ),
        expect: () => <OnboardingState>[],
      );
    });

    group('hydration', () {
      test('toJson then fromJson round-trips the state', () {
        final bloc = OnboardingBloc();
        const state = OnboardingState(activeStepIndex: 3);

        final restored = bloc.fromJson(bloc.toJson(state));

        expect(restored, equals(state));
      });

      test('toJson then fromJson round-trips populated firstLogQuantities', () {
        final bloc = OnboardingBloc();
        const state = OnboardingState(
          firstLogSelectedIds: ['a', 'b'],
          firstLogQuantities: {'a': 2.5, 'b': 1},
        );

        final restored = bloc.fromJson(bloc.toJson(state));

        expect(restored.firstLogQuantities, equals({'a': 2.5, 'b': 1.0}));
      });
    });
  });

  group(OnboardingState, () {
    test('activeSteps includes mealSchedule by default', () {
      expect(
        const OnboardingState().activeSteps,
        contains(OnboardingStep.mealSchedule),
      );
    });

    test('activeSteps drops mealSchedule when reminders are off', () {
      const state = OnboardingState(
        settings: UserSettingsState(reminderStyle: ReminderStyle.none),
      );

      expect(state.activeSteps, isNot(contains(OnboardingStep.mealSchedule)));
    });

    test('step clamps an out-of-range index to the last step', () {
      const state = OnboardingState(activeStepIndex: 99);

      expect(state.step, equals(OnboardingStep.complete));
    });

    test('step resolves the active step for the index', () {
      const state = OnboardingState(activeStepIndex: 1);

      expect(state.step, equals(OnboardingStep.buildUsuals));
    });

    group('fromJson migration', () {
      Map<String, dynamic> v0Json({
        required int activeStepIndex,
        ReminderStyle reminderStyle = ReminderStyle.onAppOpen,
      }) {
        return {
          'version': 0,
          'activeStepIndex': activeStepIndex,
          'settings': const UserSettingsState()
              .copyWith(reminderStyle: reminderStyle)
              .toJson(),
        };
      }

      test('v0 shifts an index at or past the goals insertion point up by '
          'one', () {
        final restored = OnboardingState.fromJson(
          v0Json(activeStepIndex: 5),
        );

        expect(restored.version, equals(1));
        expect(restored.activeStepIndex, equals(6));
      });

      test('v0 leaves an index before the goals insertion point unchanged', () {
        final restored = OnboardingState.fromJson(
          v0Json(activeStepIndex: 3),
        );

        expect(restored.version, equals(1));
        expect(restored.activeStepIndex, equals(3));
      });

      test('v0 uses the earlier insertion point when reminders are off', () {
        final restored = OnboardingState.fromJson(
          v0Json(activeStepIndex: 4, reminderStyle: ReminderStyle.none),
        );

        expect(restored.activeStepIndex, equals(5));
      });

      test('a newer unknown version resolves to a completed onboarding', () {
        final restored = OnboardingState.fromJson({'version': 99});

        expect(
          restored.activeStepIndex,
          equals(OnboardingStep.values.length),
        );
      });
    });
  });

  group(OnboardingStep, () {
    test('welcome and complete do not show a progress dot', () {
      expect(OnboardingStep.welcome.showsProgressDot, isFalse);
      expect(OnboardingStep.complete.showsProgressDot, isFalse);
    });

    test('other steps show a progress dot', () {
      expect(OnboardingStep.buildUsuals.showsProgressDot, isTrue);
      expect(OnboardingStep.weightTracking.showsProgressDot, isTrue);
    });
  });
}
