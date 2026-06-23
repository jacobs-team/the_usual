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
        'continuePressed advances to the next step',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(step: OnboardingStep.reminders),
        act: (bloc) => bloc.add(const OnboardingEvent.continuePressed()),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.step,
            'step',
            OnboardingStep.weightTracking,
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'backPressed returns to the previous step',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(step: OnboardingStep.weightTracking),
        act: (bloc) => bloc.add(const OnboardingEvent.backPressed()),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.step,
            'step',
            OnboardingStep.reminders,
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'continuePressed at the last step stays put',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(step: OnboardingStep.complete),
        act: (bloc) => bloc.add(const OnboardingEvent.continuePressed()),
        expect: () => <OnboardingState>[],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'markCompleted jumps to the complete step silently',
        build: OnboardingBloc.new,
        act: (bloc) => bloc.add(const OnboardingEvent.markCompleted()),
        expect: () => [
          isA<OnboardingState>()
              .having((s) => s.step, 'step', OnboardingStep.complete)
              .having((s) => s.completedSilently, 'completedSilently', isTrue),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'resetPressed returns to the default state',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(step: OnboardingStep.goals),
        act: (bloc) => bloc.add(const OnboardingEvent.resetPressed()),
        expect: () => [const OnboardingState()],
      );
    });

    group('skipPressed', () {
      blocTest<OnboardingBloc, OnboardingState>(
        'on reminders falls back to no reminders and advances',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(step: OnboardingStep.reminders),
        act: (bloc) => bloc.add(const OnboardingEvent.skipPressed()),
        expect: () => [
          isA<OnboardingState>()
              .having(
                (s) => s.settings.reminderStyle,
                'reminderStyle',
                ReminderStyle.none,
              )
              .having((s) => s.step, 'step', OnboardingStep.weightTracking),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'on weightTracking turns weight check-ins off and clears '
        'starting weight',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(
          step: OnboardingStep.weightTracking,
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
              .having((s) => s.step, 'step', OnboardingStep.goals),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'on any other step just advances',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(step: OnboardingStep.buildUsuals),
        act: (bloc) => bloc.add(const OnboardingEvent.skipPressed()),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.step,
            'step',
            OnboardingStep.firstLog,
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
        'usualsForMealReplaced keeps ids for unchanged names and drops blanks',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(
          settings: UserSettingsState(
            usuals: {
              MealOfTheDay.breakfast: [UsualMeal(id: 'a', name: 'Eggs')],
            },
          ),
        ),
        act: (bloc) => bloc.add(
          const OnboardingEvent.usualsForMealReplaced(MealOfTheDay.breakfast, [
            (name: 'Eggs', nutrition: Nutrition(calories: 200)),
            (name: 'Toast', nutrition: Nutrition(calories: 150)),
            (name: '  ', nutrition: Nutrition()),
          ]),
        ),
        expect: () => [
          isA<OnboardingState>()
              .having(
                (s) => s.settings.usuals[MealOfTheDay.breakfast],
                'breakfast usuals',
                hasLength(2),
              )
              .having(
                (s) => s.settings.usuals[MealOfTheDay.breakfast]!.first,
                'kept meal keeps its id and takes the new nutrition',
                isA<UsualMeal>()
                    .having((m) => m.id, 'id', 'a')
                    .having((m) => m.name, 'name', 'Eggs')
                    .having((m) => m.nutrition.calories, 'calories', 200),
              )
              .having(
                (s) => s.settings.usuals[MealOfTheDay.breakfast]!.last.name,
                'appended meal name',
                'Toast',
              ),
        ],
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
        const state = OnboardingState(step: OnboardingStep.goals);

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
    test('activeSteps is the full step list', () {
      expect(
        const OnboardingState().activeSteps,
        equals(OnboardingStep.values),
      );
    });

    group('fromJson migration', () {
      Map<String, dynamic> v0Json({
        required int activeStepIndex,
        ReminderStyle reminderStyle = ReminderStyle.notifications,
      }) {
        return {
          'version': 0,
          'activeStepIndex': activeStepIndex,
          'settings': const UserSettingsState()
              .copyWith(reminderStyle: reminderStyle)
              .toJson(),
        };
      }

      Map<String, dynamic> v1Json({required int activeStepIndex}) {
        return {
          'version': 1,
          'activeStepIndex': activeStepIndex,
          'settings': const UserSettingsState().toJson(),
          'firstLogSelectedIds': <String>[],
          'firstLogQuantities': <String, double>{},
        };
      }

      test('v1 index maps to the equivalent step by name', () {
        final restored = OnboardingState.fromJson(v1Json(activeStepIndex: 1));

        expect(restored.step, equals(OnboardingStep.buildUsuals));
        expect(restored.version, equals(2));
      });

      test('v1 reminderStyle index maps to reminders', () {
        // v1 order index 2 was reminderStyle.
        final restored = OnboardingState.fromJson(v1Json(activeStepIndex: 2));

        expect(restored.step, equals(OnboardingStep.reminders));
      });

      test('v1 mealSchedule index maps to reminders', () {
        // v1 order index 3 was mealSchedule.
        final restored = OnboardingState.fromJson(v1Json(activeStepIndex: 3));

        expect(restored.step, equals(OnboardingStep.reminders));
      });

      test('v1 completed users resolve to complete', () {
        // v1 order index 7 was complete.
        final restored = OnboardingState.fromJson(v1Json(activeStepIndex: 7));

        expect(restored.step, equals(OnboardingStep.complete));
      });

      test('v1 index past the end clamps to complete', () {
        final restored = OnboardingState.fromJson(v1Json(activeStepIndex: 99));

        expect(restored.step, equals(OnboardingStep.complete));
      });

      test('v0 data resolves to the equivalent step', () {
        // v0 predates goals; its order was [welcome, buildUsuals,
        // reminderStyle, mealSchedule, weightTracking, firstLog, complete], so
        // index 5 is firstLog.
        final restored = OnboardingState.fromJson(v0Json(activeStepIndex: 5));

        expect(restored.version, equals(2));
        expect(restored.step, equals(OnboardingStep.firstLog));
      });

      test('v0 mealSchedule index maps to reminders', () {
        // v0 order index 3 was mealSchedule, which collapses into reminders.
        final restored = OnboardingState.fromJson(v0Json(activeStepIndex: 3));

        expect(restored.step, equals(OnboardingStep.reminders));
      });

      test('v0 drops mealSchedule from the order when reminders are off', () {
        // Order becomes [welcome, buildUsuals, reminderStyle, weightTracking,
        // firstLog, complete], so index 4 is firstLog.
        final restored = OnboardingState.fromJson(
          v0Json(activeStepIndex: 4, reminderStyle: ReminderStyle.none),
        );

        expect(restored.step, equals(OnboardingStep.firstLog));
      });

      test('a newer unknown version resolves to a completed onboarding', () {
        final restored = OnboardingState.fromJson({'version': 99});

        expect(restored.step, equals(OnboardingStep.complete));
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
