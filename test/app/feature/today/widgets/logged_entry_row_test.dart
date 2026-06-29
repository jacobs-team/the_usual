import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(LoggedEntryRow, () {
    late DailyLogBloc dailyLogBloc;
    late UserSettingsBloc userSettingsBloc;

    void stubSettings(UserSettingsState state) {
      when(() => userSettingsBloc.state).thenReturn(state);
      when(
        () => userSettingsBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
    }

    setUp(() {
      dailyLogBloc = MockDailyLogBloc();
      when(() => dailyLogBloc.state).thenReturn(const DailyLogState());
      when(() => dailyLogBloc.stream).thenAnswer((_) => const Stream.empty());
      userSettingsBloc = MockUserSettingsBloc();
      registerFallbackValue(const DailyLogEvent.mealEntryRemoved('x'));
      registerFallbackValue(
        const DailyLogEvent.mealEntryUsualMealLinked('x', 'y'),
      );
      registerFallbackValue(
        const DailyLogEvent.mealEntryQuantityChanged('x', 1),
      );
      registerFallbackValue(
        const UserSettingsEvent.usualMealRemoved(MealOfTheDay.breakfast, 'x'),
      );
    });

    MealLogEntry entry({
      String? usualMealId,
      int? calories,
      double quantity = 1,
    }) {
      return MealLogEntry(
        id: 'm1',
        loggedAt: testNow,
        mealOfTheDay: MealOfTheDay.breakfast,
        name: 'Eggs',
        nutrition: Nutrition(calories: calories),
        usualMealId: usualMealId,
        quantity: quantity,
      );
    }

    // Expanded so the nutrition fields and any sync action are reachable.
    Future<void> pumpRow(WidgetTester tester, MealLogEntry mealLogEntry) {
      return tester.pumpPumpPumpItUP(
        deps: [dailyLogBloc, userSettingsBloc],
        LoggedEntryRow(mealLogEntry: mealLogEntry, expandedByDefault: true),
      );
    }

    testWidgets('removes the entry through the bloc', (tester) async {
      stubSettings(const UserSettingsState());
      await pumpRow(tester, entry());

      await tester.tap(find.byIcon(Icons.delete_forever_outlined));

      verify(
        () => dailyLogBloc.add(const DailyLogEvent.mealEntryRemoved('m1')),
      ).called(1);
    });

    testWidgets('saves a standalone entry as a usual and links it', (
      tester,
    ) async {
      // Saving goes through saveAsUsualMeal, which returns the new id that is
      // then linked back onto the logged entry.
      when(
        () => userSettingsBloc.saveAsUsualMeal(
          MealOfTheDay.breakfast,
          'Eggs',
          const Nutrition(calories: 400),
        ),
      ).thenReturn('new-id');
      stubSettings(const UserSettingsState());
      await pumpRow(tester, entry(calories: 400));

      // The button is right-aligned and the "Save as usual" label is short, so
      // tap the inner TextButton rather than the full-width Align's centre.
      await tester.tap(
        find.descendant(
          of: find.byType(UpdateUsualButton),
          matching: find.byType(TextButton),
        ),
      );

      verify(
        () => userSettingsBloc.saveAsUsualMeal(
          MealOfTheDay.breakfast,
          'Eggs',
          const Nutrition(calories: 400),
        ),
      ).called(1);
      verify(
        () => dailyLogBloc.add(
          const DailyLogEvent.mealEntryUsualMealLinked('m1', 'new-id'),
        ),
      ).called(1);
    });

    testWidgets('editing a standalone entry only updates the log', (
      tester,
    ) async {
      stubSettings(const UserSettingsState());
      await pumpRow(tester, entry());

      await tester.enterText(find.byType(TextFormField).first, '400');

      verify(
        () => dailyLogBloc.add(
          const DailyLogEvent.mealEntryNutritionChanged(
            'm1',
            Nutrition(calories: 400),
          ),
        ),
      ).called(1);
      verifyNever(
        () => userSettingsBloc.add(
          any(that: isA<SettingsUsualMealNutritionChanged>()),
        ),
      );
    });

    testWidgets('fills a usual meal that had none from the entry', (
      tester,
    ) async {
      stubSettings(
        const UserSettingsState(
          usuals: {
            MealOfTheDay.breakfast: [UsualMeal(id: 'u', name: 'Eggs')],
          },
        ),
      );
      // The entry carries nutrition its empty usual meal lacks, so the row
      // offers to push it onto the usual meal.
      await pumpRow(tester, entry(usualMealId: 'u', calories: 400));

      await tester.tap(find.byType(UpdateUsualButton));

      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.usualMealNutritionChanged(
            MealOfTheDay.breakfast,
            'u',
            Nutrition(calories: 400),
          ),
        ),
      ).called(1);
    });

    testWidgets('offers to update a usual meal whose nutrition now differs', (
      tester,
    ) async {
      stubSettings(
        const UserSettingsState(
          usuals: {
            MealOfTheDay.breakfast: [
              UsualMeal(
                id: 'u',
                name: 'Eggs',
                nutrition: Nutrition(calories: 300),
              ),
            ],
          },
        ),
      );
      await pumpRow(tester, entry(usualMealId: 'u', calories: 350));

      expect(find.byType(UpdateUsualButton), findsOneWidget);

      await tester.tap(find.byType(UpdateUsualButton));

      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.usualMealNutritionChanged(
            MealOfTheDay.breakfast,
            'u',
            Nutrition(calories: 350),
          ),
        ),
      ).called(1);
    });

    testWidgets('offers to clear a usual meal when the entry is empty', (
      tester,
    ) async {
      stubSettings(
        const UserSettingsState(
          usuals: {
            MealOfTheDay.breakfast: [
              UsualMeal(
                id: 'u',
                name: 'Eggs',
                nutrition: Nutrition(calories: 300),
              ),
            ],
          },
        ),
      );
      await pumpRow(tester, entry(usualMealId: 'u'));

      expect(find.byType(UpdateUsualButton), findsOneWidget);
    });

    testWidgets('shows no update button when nutrition already matches', (
      tester,
    ) async {
      stubSettings(
        const UserSettingsState(
          usuals: {
            MealOfTheDay.breakfast: [
              UsualMeal(
                id: 'u',
                name: 'Eggs',
                nutrition: Nutrition(calories: 350),
              ),
            ],
          },
        ),
      );
      await pumpRow(tester, entry(usualMealId: 'u', calories: 350));

      expect(find.byType(TextButton), findsNothing);
    });

    testWidgets('changing the quantity dispatches through the bloc', (
      tester,
    ) async {
      stubSettings(const UserSettingsState());
      await pumpRow(tester, entry(quantity: 2));

      await tester.tap(find.byIcon(Icons.add));

      verify(
        () => dailyLogBloc.add(
          const DailyLogEvent.mealEntryQuantityChanged('m1', 3),
        ),
      ).called(1);
    });

    // --- composed entry tests ---

    MealLogEntry composedEntry() {
      return MealLogEntry(
        id: 'm2',
        loggedAt: testNow,
        mealOfTheDay: MealOfTheDay.breakfast,
        name: 'Big Meal',
        nutrition: const Nutrition(calories: 700),
        components: const [
          MealComponent(
            name: 'Eggs',
            nutrition: Nutrition(calories: 300),
            quantity: 2,
          ),
          MealComponent(
            name: 'Toast',
            nutrition: Nutrition(calories: 200),
            quantity: 2,
          ),
        ],
      );
    }

    testWidgets('a composed entry shows a stepper per component', (
      tester,
    ) async {
      stubSettings(const UserSettingsState());
      registerFallbackValue(
        const DailyLogEvent.mealEntryComponentQuantityChanged('x', 0, 1),
      );
      await pumpRow(tester, composedEntry());

      expect(find.byType(QuantityStepper), findsNWidgets(2));
    });

    testWidgets('stepping a component dispatches a component quantity change', (
      tester,
    ) async {
      stubSettings(const UserSettingsState());
      registerFallbackValue(
        const DailyLogEvent.mealEntryComponentQuantityChanged('x', 0, 1),
      );
      await pumpRow(tester, composedEntry());

      // Tap the add button in the first component row.
      await tester.tap(find.byIcon(Icons.add).first);

      verify(
        () => dailyLogBloc.add(
          any(
            that: isA<MealEntryComponentQuantityChanged>()
                .having((e) => e.componentIndex, 'componentIndex', 0),
          ),
        ),
      ).called(1);
    });

    testWidgets('a plain entry still renders the single nutrition row', (
      tester,
    ) async {
      stubSettings(const UserSettingsState());
      await pumpRow(tester, entry());

      expect(find.byType(ExpandableNutrition), findsOneWidget);
      expect(find.byType(QuantityStepper), findsOneWidget);
    });

    // --- composed entry usual-meal footer tests ---

    MealLogEntry composedEntryWith({
      String? usualMealId,
      List<MealComponent>? components,
      Nutrition? nutrition,
    }) {
      return MealLogEntry(
        id: 'm2',
        loggedAt: testNow,
        mealOfTheDay: MealOfTheDay.breakfast,
        name: 'Big Meal',
        nutrition: nutrition ?? const Nutrition(calories: 700),
        usualMealId: usualMealId,
        components: components ??
            const [
              MealComponent(
                name: 'Eggs',
                nutrition: Nutrition(calories: 300),
                quantity: 2,
              ),
              MealComponent(
                name: 'Toast',
                nutrition: Nutrition(calories: 200),
                quantity: 2,
              ),
            ],
      );
    }

    testWidgets(
      'an unlinked composed entry offers Save as usual',
      (tester) async {
        when(
          () => userSettingsBloc.saveAsUsualMeal(
            MealOfTheDay.breakfast,
            'Big Meal',
            const Nutrition(calories: 700),
            components: [
              const MealComponent(
                name: 'Eggs',
                nutrition: Nutrition(calories: 300),
                quantity: 2,
              ),
              const MealComponent(
                name: 'Toast',
                nutrition: Nutrition(calories: 200),
                quantity: 2,
              ),
            ],
          ),
        ).thenReturn('new-composed-id');
        registerFallbackValue(
          const DailyLogEvent.mealEntryComponentQuantityChanged('x', 0, 1),
        );
        stubSettings(const UserSettingsState());
        await pumpRow(tester, composedEntryWith());

        expect(find.byType(UpdateUsualButton), findsOneWidget);

        await tester.tap(
          find.descendant(
            of: find.byType(UpdateUsualButton),
            matching: find.byType(TextButton),
          ),
        );

        verify(
          () => userSettingsBloc.saveAsUsualMeal(
            MealOfTheDay.breakfast,
            'Big Meal',
            const Nutrition(calories: 700),
            components: [
              const MealComponent(
                name: 'Eggs',
                nutrition: Nutrition(calories: 300),
                quantity: 2,
              ),
              const MealComponent(
                name: 'Toast',
                nutrition: Nutrition(calories: 200),
                quantity: 2,
              ),
            ],
          ),
        ).called(1);
        verify(
          () => dailyLogBloc.add(
            const DailyLogEvent.mealEntryUsualMealLinked(
              'm2',
              'new-composed-id',
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'a linked composed entry that differs offers Update usual meal to match',
      (tester) async {
        registerFallbackValue(
          const DailyLogEvent.mealEntryComponentQuantityChanged('x', 0, 1),
        );
        registerFallbackValue(
          const UserSettingsEvent.usualMealComponentsChanged(
            MealOfTheDay.breakfast,
            'u',
            [],
            Nutrition(),
          ),
        );
        // The usual meal has different components than the log entry.
        stubSettings(
          const UserSettingsState(
            usuals: {
              MealOfTheDay.breakfast: [
                UsualMeal(
                  id: 'u',
                  name: 'Big Meal',
                  nutrition: Nutrition(calories: 500),
                  components: [
                    MealComponent(
                      name: 'Eggs',
                      nutrition: Nutrition(calories: 100),
                    ),
                  ],
                ),
              ],
            },
          ),
        );
        await pumpRow(tester, composedEntryWith(usualMealId: 'u'));

        expect(find.byType(UpdateUsualButton), findsOneWidget);

        await tester.tap(
          find.descendant(
            of: find.byType(UpdateUsualButton),
            matching: find.byType(TextButton),
          ),
        );

        verify(
          () => userSettingsBloc.add(
            any(that: isA<SettingsUsualMealComponentsChanged>()),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'delete button on a composed entry dispatches mealEntryRemoved',
      (tester) async {
        registerFallbackValue(
          const DailyLogEvent.mealEntryComponentQuantityChanged('x', 0, 1),
        );
        stubSettings(const UserSettingsState());
        await pumpRow(tester, composedEntry());

        await tester.tap(find.byIcon(Icons.delete_forever_outlined));

        verify(
          () => dailyLogBloc.add(
            const DailyLogEvent.mealEntryRemoved('m2'),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'tapping a component row expands nutrition fields; '
      'editing calories dispatches mealEntryComponentNutritionChanged',
      (tester) async {
        registerFallbackValue(
          const DailyLogEvent.mealEntryComponentQuantityChanged('x', 0, 1),
        );
        registerFallbackValue(
          const DailyLogEvent.mealEntryComponentNutritionChanged(
            'x',
            0,
            Nutrition(),
          ),
        );
        stubSettings(const UserSettingsState());
        await pumpRow(tester, composedEntry());

        // Tap the InkWell wrapping the first component row to expand it.
        await tester.tap(
          find
              .descendant(
                of: find.byType(InkWell),
                matching: find.text('Eggs'),
              )
              .first,
        );
        await tester.pump();

        // NutritionFields is now visible for the expanded row.
        expect(find.byType(NutritionFields), findsWidgets);

        // Enter a value in the first TextFormField (calories).
        await tester.enterText(
          find.byType(TextFormField).first,
          '350',
        );

        verify(
          () => dailyLogBloc.add(
            any(
              that: isA<MealEntryComponentNutritionChanged>()
                  .having((e) => e.id, 'id', 'm2')
                  .having(
                    (e) => e.componentIndex,
                    'componentIndex',
                    0,
                  ),
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'a linked composed entry identical to its usual shows no footer',
      (tester) async {
        registerFallbackValue(
          const DailyLogEvent.mealEntryComponentQuantityChanged('x', 0, 1),
        );
        const matchingComponents = [
          MealComponent(
            name: 'Eggs',
            nutrition: Nutrition(calories: 300),
            quantity: 2,
          ),
          MealComponent(
            name: 'Toast',
            nutrition: Nutrition(calories: 200),
            quantity: 2,
          ),
        ];
        stubSettings(
          const UserSettingsState(
            usuals: {
              MealOfTheDay.breakfast: [
                UsualMeal(
                  id: 'u',
                  name: 'Big Meal',
                  nutrition: Nutrition(calories: 700),
                  components: matchingComponents,
                ),
              ],
            },
          ),
        );
        await pumpRow(
          tester,
          composedEntryWith(
            usualMealId: 'u',
            nutrition: const Nutrition(calories: 700),
            components: matchingComponents,
          ),
        );

        expect(find.byType(UpdateUsualButton), findsNothing);
      },
    );
  });
}
