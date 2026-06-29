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
    when(() => repository.isConfigured).thenReturn(true);
    when(() => userSettingsBloc.state).thenReturn(
      const UserSettingsState(),
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
        const MealEntryEvent.started(
          initialFoods: [FoodDraft(id: 'x', name: 'Toast')],
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
      'started seeds photos into state',
      build: build,
      act: (bloc) => bloc.add(
        MealEntryEvent.started(
          photos: [MealPhoto(bytes: transparentPixel)],
        ),
      ),
      expect: () => [
        isA<MealEntryState>().having((s) => s.photos, 'photos', hasLength(1)),
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
      act: (bloc) =>
          bloc.add(const MealEntryEvent.foodNameChanged('a', 'Eggs')),
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
      act: (bloc) => bloc.add(
        const MealEntryEvent.mealOfTheDayChanged(MealOfTheDay.lunch),
      ),
      expect: () => [
        isA<MealEntryState>().having(
          (s) => s.mealOfTheDay,
          'slot',
          MealOfTheDay.lunch,
        ),
      ],
    );

    blocTest<FoodEntryBloc, MealEntryState>(
      'photosCleared empties the photo list',
      build: build,
      seed: () => MealEntryState(
        photos: [MealPhoto(bytes: transparentPixel)],
      ),
      act: (bloc) => bloc.add(const MealEntryEvent.photosCleared()),
      expect: () => [
        isA<MealEntryState>().having((s) => s.photos, 'photos', isEmpty),
      ],
    );

    group('photoRemoved', () {
      blocTest<FoodEntryBloc, MealEntryState>(
        'drops the photo at the given index',
        build: build,
        seed: () => MealEntryState(
          photos: [
            MealPhoto(bytes: transparentPixel),
            MealPhoto(bytes: transparentPixel),
          ],
        ),
        act: (bloc) => bloc.add(const MealEntryEvent.photoRemoved(0)),
        expect: () => [
          isA<MealEntryState>().having((s) => s.photos, 'photos', hasLength(1)),
        ],
      );

      blocTest<FoodEntryBloc, MealEntryState>(
        'ignores an out-of-range index',
        build: build,
        seed: () => MealEntryState(
          photos: [MealPhoto(bytes: transparentPixel)],
        ),
        act: (bloc) => bloc.add(const MealEntryEvent.photoRemoved(5)),
        expect: () => <MealEntryState>[],
      );
    });

    blocTest<FoodEntryBloc, MealEntryState>(
      'mealNameChanged updates the meal name',
      build: build,
      act: (bloc) => bloc.add(const MealEntryEvent.mealNameChanged('Bowl')),
      expect: () => [
        isA<MealEntryState>().having((s) => s.mealName, 'mealName', 'Bowl'),
      ],
    );

    blocTest<FoodEntryBloc, MealEntryState>(
      'foodPicked appends a linked, pre-filled row',
      build: build,
      act: (bloc) => bloc.add(const MealEntryEvent.foodPicked(
        UsualFood(
          id: 'f1',
          name: 'Chicken, 1 oz',
          nutrition: Nutrition(calories: 22, protein: 5),
        ),
      )),
      verify: (bloc) {
        final foodDraft = bloc.state.foods.last;
        expect(foodDraft.name, equals('Chicken, 1 oz'));
        expect(foodDraft.usualFoodId, equals('f1'));
        expect(foodDraft.nutrition.calories, equals(22));
      },
    );

    blocTest<FoodEntryBloc, MealEntryState>(
      'foodSavedAsUsual stamps the link onto the row',
      build: build,
      seed: () => const MealEntryState(
        foods: [FoodDraft(id: 'd1', name: 'Rice, 100 g')],
      ),
      act: (bloc) => bloc.add(
        const MealEntryEvent.foodSavedAsUsual('d1', 'f2'),
      ),
      expect: () => [
        isA<MealEntryState>().having(
          (s) => s.foods.single.usualFoodId,
          'usualFoodId',
          'f2',
        ),
      ],
    );

    group('estimateRequested without an API key', () {
      blocTest<FoodEntryBloc, MealEntryState>(
        'a named row fails when the AI is not configured',
        build: build,
        setUp: () => when(() => repository.isConfigured).thenReturn(false),
        seed: () => const MealEntryState(
          foods: [FoodDraft(id: 'a', name: 'eggs')],
        ),
        act: (bloc) => bloc.add(const MealEntryEvent.estimateRequested()),
        expect: () => [
          isA<MealEntryState>()
              .having((s) => s.status, 'status', MealEntryStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );

      blocTest<FoodEntryBloc, MealEntryState>(
        'a photo estimate fails when the AI is not configured',
        build: build,
        setUp: () => when(() => repository.isConfigured).thenReturn(false),
        seed: () => MealEntryState(
          photos: [MealPhoto(bytes: transparentPixel)],
        ),
        act: (bloc) => bloc.add(const MealEntryEvent.estimateRequested()),
        expect: () => [
          isA<MealEntryState>()
              .having((s) => s.status, 'status', MealEntryStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );
    });

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
        seed: () => const MealEntryState(
          foods: [FoodDraft(id: 'a', name: 'mystery')],
        ),
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

      blocTest<FoodEntryBloc, MealEntryState>(
        'multiple named rows are each estimated in place, keeping their names',
        build: build,
        setUp: () {
          when(
            () => repository.suggestFromDescription(
              'chicken',
              mode: any(named: 'mode'),
            ),
          ).thenAnswer(
            (_) async => const [
              AiMealSuggestion(
                name: 'Chicken',
                nutrition: Nutrition(calories: 200),
              ),
            ],
          );
          when(
            () => repository.suggestFromDescription(
              'rice',
              mode: any(named: 'mode'),
            ),
          ).thenAnswer(
            (_) async => const [
              AiMealSuggestion(
                name: 'Rice',
                nutrition: Nutrition(calories: 150),
              ),
            ],
          );
        },
        seed: () => const MealEntryState(
          foods: [
            FoodDraft(id: 'a', name: 'chicken'),
            FoodDraft(id: 'b', name: 'rice'),
          ],
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
              .having((s) => s.foods, 'foods', hasLength(2))
              .having((s) => s.foods[0].name, 'row-0 name', 'chicken')
              .having(
                (s) => s.foods[0].nutrition.calories,
                'row-0 calories',
                200,
              )
              .having((s) => s.foods[1].name, 'row-1 name', 'rice')
              .having(
                (s) => s.foods[1].nutrition.calories,
                'row-1 calories',
                150,
              ),
        ],
      );
    });

    group('estimateRequested in itemized mode', () {
      blocTest<FoodEntryBloc, MealEntryState>(
        'itemized estimate fills component rows and keeps the meal name',
        build: () {
          when(
            () => repository.suggestFromDescription(
              any(),
              mode: MealEntryMode.itemized,
            ),
          ).thenAnswer(
            (_) async => const [
              AiMealSuggestion(
                name: 'Chicken, 1 oz',
                quantity: 4,
                nutrition: Nutrition(calories: 22, protein: 5),
              ),
              AiMealSuggestion(
                name: 'Rice, cup',
                nutrition: Nutrition(calories: 205, carbs: 45),
              ),
            ],
          );
          return build();
        },
        seed: () => const MealEntryState(
          mealEntryMode: MealEntryMode.itemized,
          mealName: 'Chicken & rice bowl',
          foods: [FoodDraft(id: 'seed', name: 'chicken and rice')],
        ),
        act: (bloc) => bloc.add(const MealEntryEvent.estimateRequested()),
        expect: () => [
          isA<MealEntryState>().having(
            (s) => s.isGenerating,
            'generating',
            isTrue,
          ),
          isA<MealEntryState>()
              .having((s) => s.foods.length, 'rows', 2)
              .having((s) => s.mealName, 'mealName', 'Chicken & rice bowl'),
        ],
      );

      blocTest<FoodEntryBloc, MealEntryState>(
        'itemized estimate sets mealName from typed row when mealName is empty',
        build: () {
          when(
            () => repository.suggestFromDescription(
              any(),
              mode: MealEntryMode.itemized,
            ),
          ).thenAnswer(
            (_) async => const [
              AiMealSuggestion(
                name: 'Chicken, 1 oz',
                nutrition: Nutrition(calories: 22, protein: 5),
              ),
              AiMealSuggestion(
                name: 'Rice, cup',
                nutrition: Nutrition(calories: 205, carbs: 45),
              ),
            ],
          );
          return build();
        },
        seed: () => const MealEntryState(
          mealEntryMode: MealEntryMode.itemized,
          foods: [FoodDraft(id: 'seed', name: 'chicken and rice')],
        ),
        act: (bloc) => bloc.add(const MealEntryEvent.estimateRequested()),
        expect: () => [
          isA<MealEntryState>().having(
            (s) => s.isGenerating,
            'generating',
            isTrue,
          ),
          isA<MealEntryState>()
              .having((s) => s.foods.length, 'rows', 2)
              .having(
                (s) => s.mealName,
                'mealName',
                'chicken and rice',
              ),
        ],
      );
    });

    group('estimateRequested with photos in itemized mode', () {
      blocTest<FoodEntryBloc, MealEntryState>(
        'photo estimate in itemized mode with typed row and empty mealName '
        'resolves mealName from the typed description',
        build: build,
        setUp: () {
          when(
            () => repository.suggestFromPhoto(
              any(),
              mode: any(named: 'mode'),
              description: any(named: 'description'),
            ),
          ).thenAnswer(
            (_) async => const [
              AiMealSuggestion(
                name: 'Chicken, 1 oz',
                nutrition: Nutrition(calories: 22, protein: 5),
              ),
            ],
          );
        },
        seed: () => MealEntryState(
          mealEntryMode: MealEntryMode.itemized,
          photos: [MealPhoto(bytes: transparentPixel)],
          foods: const [FoodDraft(id: 'a', name: 'chicken and rice')],
        ),
        act: (bloc) => bloc.add(const MealEntryEvent.estimateRequested()),
        verify: (bloc) {
          expect(
            bloc.state.mealName,
            equals('chicken and rice'),
          );
        },
      );

      blocTest<FoodEntryBloc, MealEntryState>(
        'photo estimate in itemized mode keeps an existing mealName',
        build: build,
        setUp: () {
          when(
            () => repository.suggestFromPhoto(
              any(),
              mode: any(named: 'mode'),
              description: any(named: 'description'),
            ),
          ).thenAnswer(
            (_) async => const [
              AiMealSuggestion(
                name: 'Chicken, 1 oz',
                nutrition: Nutrition(calories: 22, protein: 5),
              ),
            ],
          );
        },
        seed: () => MealEntryState(
          mealEntryMode: MealEntryMode.itemized,
          mealName: 'My bowl',
          photos: [MealPhoto(bytes: transparentPixel)],
          foods: const [FoodDraft(id: 'a', name: 'chicken and rice')],
        ),
        act: (bloc) => bloc.add(const MealEntryEvent.estimateRequested()),
        verify: (bloc) {
          expect(bloc.state.mealName, equals('My bowl'));
        },
      );
    });

    group('estimateRequested with photos attached', () {
      blocTest<FoodEntryBloc, MealEntryState>(
        'success: emits generating then idle with nutrition filled',
        build: build,
        setUp: () {
          when(
            () => repository.suggestFromPhoto(
              any(),
              mode: any(named: 'mode'),
              description: any(named: 'description'),
            ),
          ).thenAnswer(
            (_) async => const [
              AiMealSuggestion(
                name: 'Salad',
                nutrition: Nutrition(calories: 120),
              ),
            ],
          );
        },
        seed: () => MealEntryState(
          photos: [MealPhoto(bytes: transparentPixel)],
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
                120,
              ),
        ],
      );

      blocTest<FoodEntryBloc, MealEntryState>(
        'failure: emits generating then failure with an error message',
        build: build,
        setUp: () {
          when(
            () => repository.suggestFromPhoto(
              any(),
              mode: any(named: 'mode'),
              description: any(named: 'description'),
            ),
          ).thenThrow(StateError('photo error'));
        },
        seed: () => MealEntryState(
          photos: [MealPhoto(bytes: transparentPixel)],
        ),
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
