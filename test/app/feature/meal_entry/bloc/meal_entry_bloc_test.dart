import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
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
  });
}
