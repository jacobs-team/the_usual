import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(OnboardingBloc, () {
    setUp(initHydratedStorage);

    test('initial state starts at ${OnboardingStep.welcome}', () {
      expect(
        OnboardingBloc().state,
        isA<OnboardingState>().having(
          (s) => s.step,
          'step',
          equals(OnboardingStep.welcome),
        ),
      );
    });

    blocTest<OnboardingBloc, OnboardingState>(
      'emits ${OnboardingStep.buildUsuals} when $GetStartedPressed is added',
      build: OnboardingBloc.new,
      act: (bloc) => bloc.add(const OnboardingEvent.getStartedPressed()),
      expect: () => [
        isA<OnboardingState>().having(
          (s) => s.step,
          'step',
          equals(OnboardingStep.buildUsuals),
        ),
      ],
    );

    group('navigation', () {
      blocTest<OnboardingBloc, OnboardingState>(
        'continue from ${OnboardingStep.reminderStyle} goes to '
        '${OnboardingStep.mealSchedule} when reminders are on',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(
          step: OnboardingStep.reminderStyle,
          reminderStyle: ReminderStyle.notifications,
        ),
        act: (bloc) => bloc.add(const OnboardingEvent.continuePressed()),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.step,
            'step',
            equals(OnboardingStep.mealSchedule),
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'continue from ${OnboardingStep.reminderStyle} skips '
        '${OnboardingStep.mealSchedule} when reminders are off',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(
          step: OnboardingStep.reminderStyle,
          reminderStyle: ReminderStyle.none,
        ),
        act: (bloc) => bloc.add(const OnboardingEvent.continuePressed()),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.step,
            'step',
            equals(OnboardingStep.weightTracking),
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'skip from ${OnboardingStep.reminderStyle} with no choice skips '
        '${OnboardingStep.mealSchedule}',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(step: OnboardingStep.reminderStyle),
        act: (bloc) => bloc.add(const OnboardingEvent.skipPressed()),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.step,
            'step',
            equals(OnboardingStep.weightTracking),
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'back from ${OnboardingStep.weightTracking} returns to '
        '${OnboardingStep.reminderStyle} when reminders are off',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(
          step: OnboardingStep.weightTracking,
          reminderStyle: ReminderStyle.none,
        ),
        act: (bloc) => bloc.add(const OnboardingEvent.backPressed()),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.step,
            'step',
            equals(OnboardingStep.reminderStyle),
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'back from ${OnboardingStep.weightTracking} returns to '
        '${OnboardingStep.mealSchedule} when reminders are on',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(
          step: OnboardingStep.weightTracking,
          reminderStyle: ReminderStyle.onAppOpen,
        ),
        act: (bloc) => bloc.add(const OnboardingEvent.backPressed()),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.step,
            'step',
            equals(OnboardingStep.mealSchedule),
          ),
        ],
      );
    });

    group('usuals', () {
      blocTest<OnboardingBloc, OnboardingState>(
        'adds a trimmed item to the selected meal',
        build: OnboardingBloc.new,
        act: (bloc) => bloc.add(
          const OnboardingEvent.usualAdded(
            MealOfTheDay.breakfast,
            '  Oatmeal  ',
          ),
        ),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.usuals[MealOfTheDay.breakfast]?.map((i) => i.name),
            'breakfast item names',
            equals(['Oatmeal']),
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'ignores blank and duplicate names',
        build: OnboardingBloc.new,
        act: (bloc) => bloc
          ..add(const OnboardingEvent.usualAdded(MealOfTheDay.lunch, 'Salad'))
          ..add(const OnboardingEvent.usualAdded(MealOfTheDay.lunch, '   '))
          ..add(const OnboardingEvent.usualAdded(MealOfTheDay.lunch, 'salad')),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.usuals[MealOfTheDay.lunch],
            'lunch items',
            hasLength(1),
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'removes an item and deselects it from the first log',
        build: OnboardingBloc.new,
        act: (bloc) async {
          bloc.add(
            const OnboardingEvent.usualAdded(MealOfTheDay.dinner, 'Tacos'),
          );
          await Future<void>.delayed(Duration.zero);
          final id = bloc.state.usuals[MealOfTheDay.dinner]!.first.id;
          bloc
            ..add(OnboardingEvent.firstLogItemToggled(id))
            ..add(OnboardingEvent.usualRemoved(MealOfTheDay.dinner, id));
        },
        verify: (bloc) {
          expect(bloc.state.usuals[MealOfTheDay.dinner], isEmpty);
          expect(bloc.state.firstLogSelectedIds, isEmpty);
        },
      );
    });

    group('first log', () {
      blocTest<OnboardingBloc, OnboardingState>(
        'something else adds the item to usuals and selects it',
        build: OnboardingBloc.new,
        act: (bloc) => bloc.add(
          const OnboardingEvent.somethingElseLogged(
            MealOfTheDay.lunch,
            'Ramen',
          ),
        ),
        verify: (bloc) {
          final item = bloc.state.usuals[MealOfTheDay.lunch]!.single;
          expect(item.name, equals('Ramen'));
          expect(bloc.state.firstLogSelectedIds, equals([item.id]));
        },
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'completing the first log finishes onboarding',
        build: OnboardingBloc.new,
        seed: () => const OnboardingState(step: OnboardingStep.firstLog),
        act: (bloc) => bloc.add(const OnboardingEvent.firstLogCompleted()),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.step,
            'step',
            equals(OnboardingStep.complete),
          ),
        ],
      );
    });

    group('schedule', () {
      blocTest<OnboardingBloc, OnboardingState>(
        'toggling a meal reminder keeps its time',
        build: OnboardingBloc.new,
        act: (bloc) => bloc.add(
          const OnboardingEvent.mealReminderToggled(
            MealOfTheDay.snacks,
            enabled: true,
          ),
        ),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.mealReminders[MealOfTheDay.snacks],
            'snacks reminder',
            isA<MealReminder>()
                .having((r) => r.enabled, 'enabled', isTrue)
                .having((r) => r.hour, 'hour', equals(15)),
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'changing a meal reminder time keeps it enabled',
        build: OnboardingBloc.new,
        act: (bloc) => bloc.add(
          const OnboardingEvent.mealReminderTimeChanged(
            MealOfTheDay.lunch,
            12,
            30,
          ),
        ),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.mealReminders[MealOfTheDay.lunch],
            'lunch reminder',
            isA<MealReminder>()
                .having((r) => r.enabled, 'enabled', isTrue)
                .having((r) => r.hour, 'hour', equals(12))
                .having((r) => r.minute, 'minute', equals(30)),
          ),
        ],
      );
    });

    test('toJson and fromJson round-trip the collected setup', () {
      final bloc = OnboardingBloc();
      const state = OnboardingState(
        step: OnboardingStep.weightTracking,
        usuals: {
          MealOfTheDay.breakfast: [UsualMeal(id: '1', name: 'Oatmeal')],
        },
        reminderStyle: ReminderStyle.notifications,
        scheduleMode: ScheduleMode.endOfDay,
        startingWeight: 172.5,
        weightUnit: WeightUnit.kg,
      );

      final restored = bloc.fromJson(bloc.toJson(state));

      expect(restored, equals(state));
    });
  });
}
