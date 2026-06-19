import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(MealEntryMode.wholeMeal);
  });

  late MockMealAiRepository repository;
  late MockUserSettingsBloc userSettingsBloc;

  setUp(() {
    repository = MockMealAiRepository();
    userSettingsBloc = MockUserSettingsBloc();
    when(() => userSettingsBloc.state).thenReturn(
      const UserSettingsState(mealEntryMode: MealEntryMode.wholeMeal),
    );
  });

  FoodEntryBloc build() => FoodEntryBloc(repository, userSettingsBloc);

  group(FoodEntryBloc, () {
    blocTest<FoodEntryBloc, MealEntryState>(
      'started seeds one empty row and the mode from settings',
      build: build,
      act: (bloc) => bloc.add(const MealEntryEvent.started()),
      expect: () => [
        isA<MealEntryState>()
            .having((s) => s.foods, 'foods', hasLength(1))
            .having(
              (s) => s.mealEntryMode,
              'mealEntryMode',
              MealEntryMode.wholeMeal,
            ),
      ],
    );

    blocTest<FoodEntryBloc, MealEntryState>(
      'started seeds the supplied foods and slot',
      build: build,
      act: (bloc) => bloc.add(
        MealEntryEvent.started(
          initialFoods: const [FoodDraft(id: 'x', name: 'Toast')],
          mealOfTheDay: MealOfTheDay.dinner,
        ),
      ),
      expect: () => [
        isA<MealEntryState>()
            .having((s) => s.foods.single.name, 'name', 'Toast')
            .having((s) => s.mealOfTheDay, 'slot', MealOfTheDay.dinner),
      ],
    );

    blocTest<FoodEntryBloc, MealEntryState>(
      'foodAdded appends an empty row',
      build: build,
      seed: () => const MealEntryState(foods: [FoodDraft(id: 'a')]),
      act: (bloc) => bloc.add(const MealEntryEvent.foodAdded()),
      expect: () => [
        isA<MealEntryState>().having((s) => s.foods, 'foods', hasLength(2)),
      ],
    );

    blocTest<FoodEntryBloc, MealEntryState>(
      'foodNameChanged updates the matching row',
      build: build,
      seed: () => const MealEntryState(foods: [FoodDraft(id: 'a')]),
      act: (bloc) => bloc.add(const MealEntryEvent.foodNameChanged('a', 'Eggs')),
      expect: () => [
        isA<MealEntryState>().having(
          (s) => s.foods.single.name,
          'name',
          'Eggs',
        ),
      ],
    );

    blocTest<FoodEntryBloc, MealEntryState>(
      'foodRemoved keeps at least one row',
      build: build,
      seed: () => const MealEntryState(foods: [FoodDraft(id: 'a')]),
      act: (bloc) => bloc.add(const MealEntryEvent.foodRemoved('a')),
      expect: () => [
        isA<MealEntryState>().having((s) => s.foods, 'foods', hasLength(1)),
      ],
    );

    blocTest<FoodEntryBloc, MealEntryState>(
      'entryModeToggled updates state and persists to settings',
      build: build,
      act: (bloc) => bloc.add(
        const MealEntryEvent.entryModeToggled(MealEntryMode.itemized),
      ),
      expect: () => [
        isA<MealEntryState>().having(
          (s) => s.mealEntryMode,
          'mode',
          MealEntryMode.itemized,
        ),
      ],
      verify: (_) {
        verify(
          () => userSettingsBloc.add(
            const UserSettingsEvent.mealEntryModeChanged(
              MealEntryMode.itemized,
            ),
          ),
        ).called(1);
      },
    );

    blocTest<FoodEntryBloc, MealEntryState>(
      'mealOfTheDayChanged updates the slot',
      build: build,
      act: (bloc) =>
          bloc.add(const MealEntryEvent.mealOfTheDayChanged(MealOfTheDay.lunch)),
      expect: () => [
        isA<MealEntryState>().having(
          (s) => s.mealOfTheDay,
          'slot',
          MealOfTheDay.lunch,
        ),
      ],
    );

    group('estimateRequested', () {
      blocTest<FoodEntryBloc, MealEntryState>(
        'a single named row is estimated and the rows are replaced',
        build: build,
        setUp: () {
          when(
            () => repository.suggestFromDescription(
              any(),
              mode: any(named: 'mode'),
            ),
          ).thenAnswer(
            (_) async => const [
              AiMealSuggestion(
                name: '2 eggs & toast',
                nutrition: Nutrition(calories: 350),
              ),
            ],
          );
        },
        seed: () => const MealEntryState(
          foods: [FoodDraft(id: 'a', name: 'eggs and toast')],
        ),
        act: (bloc) => bloc.add(const MealEntryEvent.estimateRequested()),
        expect: () => [
          isA<MealEntryState>().having(
            (s) => s.status,
            'status',
            MealEntryStatus.generating,
          ),
          isA<MealEntryState>()
              .having((s) => s.status, 'status', MealEntryStatus.idle)
              .having(
                (s) => s.foods.single.nutrition.calories,
                'calories',
                350,
              )
              // whole-meal keeps the typed description as the name
              .having((s) => s.foods.single.name, 'name', 'eggs and toast'),
        ],
      );

      blocTest<FoodEntryBloc, MealEntryState>(
        'a repository failure ends in failure status with a message',
        build: build,
        setUp: () {
          when(
            () => repository.suggestFromDescription(
              any(),
              mode: any(named: 'mode'),
            ),
          ).thenThrow(StateError('boom'));
        },
        seed: () =>
            const MealEntryState(foods: [FoodDraft(id: 'a', name: 'mystery')]),
        act: (bloc) => bloc.add(const MealEntryEvent.estimateRequested()),
        expect: () => [
          isA<MealEntryState>().having(
            (s) => s.status,
            'status',
            MealEntryStatus.generating,
          ),
          isA<MealEntryState>()
              .having((s) => s.status, 'status', MealEntryStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );
    });
  });
}
