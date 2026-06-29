import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(
      const UserSettingsEvent.usualFoodNameChanged('', ''),
    );
    registerFallbackValue(
      const UserSettingsEvent.usualFoodNutritionChanged('', Nutrition()),
    );
    registerFallbackValue(
      const UserSettingsEvent.usualFoodPropagatedToMeals('', Nutrition()),
    );
    registerFallbackValue(
      const UserSettingsEvent.usualFoodAdded('', Nutrition()),
    );
    registerFallbackValue(
      const UserSettingsEvent.usualFoodRemoved(''),
    );
  });

  group(UsualFoodsView, () {
    late UserSettingsBloc userSettingsBloc;

    void stub(UserSettingsState state) {
      when(() => userSettingsBloc.state).thenReturn(state);
      when(
        () => userSettingsBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
    }

    setUp(() {
      userSettingsBloc = MockUserSettingsBloc();
    });

    testWidgets('renders an editable card per usual food', (tester) async {
      stub(
        const UserSettingsState(
          usualFoods: [
            UsualFood(id: 'a', name: 'Chicken, 1 oz'),
            UsualFood(id: 'b', name: 'Oats, 1 cup'),
          ],
        ),
      );
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const UsualFoodsView(),
      );

      expect(find.byType(ExpandableNutrition), findsNWidgets(2));
    });

    testWidgets('shows an empty state when the library is empty', (
      tester,
    ) async {
      stub(const UserSettingsState());
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const UsualFoodsView(),
      );

      expect(find.byType(ExpandableNutrition), findsNothing);
      expect(find.byKey(const Key('usualFoodsEmpty')), findsOneWidget);
    });

    testWidgets('editing a food name dispatches usualFoodNameChanged', (
      tester,
    ) async {
      stub(
        const UserSettingsState(
          expandNutritionByDefault: true,
          usualFoods: [UsualFood(id: 'a', name: 'Chicken, 1 oz')],
        ),
      );
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const UsualFoodsView(),
      );

      final nameField = find
          .descendant(
            of: find.byType(ExpandableNutrition),
            matching: find.byType(EditableText),
          )
          .first;
      await tester.enterText(nameField, 'Chicken, 2 oz');

      verify(
        () => userSettingsBloc.add(
          any(that: isA<SettingsUsualFoodNameChanged>()),
        ),
      ).called(greaterThan(0));
    });

    testWidgets('the FAB is present to add a food', (tester) async {
      stub(const UserSettingsState());
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpPumpPumpItUP(
        const UsualFoodsView(),
        deps: [userSettingsBloc],
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets(
      'tapping the FAB opens FoodEntrySheet and dispatches '
      'usualFoodAdded on confirm',
      (tester) async {
        stub(const UserSettingsState());
        final mealAiRepository = MockMealAiRepository();
        when(() => mealAiRepository.isConfigured).thenReturn(false);
        tester.view.physicalSize = const Size(1200, 3000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpPumpPumpItUP(
          const UsualFoodsView(),
          deps: [userSettingsBloc, mealAiRepository],
        );

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
        await tester.enterText(
          find
              .descendant(
                of: find.byType(FoodEntrySheet),
                matching: find.byType(TextFormField),
              )
              .first,
          'Chicken, 1 oz',
        );
        await tester.pump();
        await tester.tap(
          find.descendant(
            of: find.byType(FoodEntrySheet),
            matching: find.byType(FilledButton),
          ),
        );
        await tester.pumpAndSettle();

        verify(
          () => userSettingsBloc.add(
            any(that: isA<SettingsUsualFoodAdded>()),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'tapping delete icon shows ConfirmDialog and dispatches '
      'usualFoodRemoved on confirm',
      (tester) async {
        const usualFood = UsualFood(id: 'del-1', name: 'Oats, 1 cup');
        stub(
          const UserSettingsState(usualFoods: [usualFood]),
        );
        tester.view.physicalSize = const Size(1200, 3000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpPumpPumpItUP(
          const UsualFoodsView(),
          deps: [userSettingsBloc],
        );

        await tester.tap(
          find.byIcon(Icons.delete_forever_outlined),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ConfirmDialog), findsOneWidget);

        await tester.tap(
          find.byKey(const Key('confirm-dialog-confirm')),
        );
        await tester.pumpAndSettle();

        verify(
          () => userSettingsBloc.add(
            const UserSettingsEvent.usualFoodRemoved('del-1'),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'editing nutrition on a food used by 2 meals shows ConfirmDialog and '
      'dispatches usualFoodPropagatedToMeals on confirm',
      (tester) async {
        // Seed state: food f1 appears as a component in 2 usual meals across
        // different timings, so usualMealsUsingFood('f1') returns 2.
        const usualFood = UsualFood(
          id: 'f1',
          name: 'Oats, 1 cup',
          nutrition: Nutrition(calories: 300),
        );
        const mealWithFood = UsualMeal(
          id: 'm1',
          name: 'Breakfast Bowl',
          components: [
            MealComponent(name: 'Oats, 1 cup', usualFoodId: 'f1'),
          ],
        );
        const anotherMealWithFood = UsualMeal(
          id: 'm2',
          name: 'Morning Mix',
          components: [
            MealComponent(name: 'Oats, 1 cup', usualFoodId: 'f1'),
          ],
        );
        stub(
          const UserSettingsState(
            expandNutritionByDefault: true,
            usualFoods: [usualFood],
            usuals: {
              MealOfTheDay.breakfast: [mealWithFood],
              MealOfTheDay.lunch: [anotherMealWithFood],
            },
          ),
        );
        tester.view.physicalSize = const Size(1200, 3000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpPumpPumpItUP(
          deps: [userSettingsBloc],
          const UsualFoodsView(),
        );

        // Edit a nutrition field to trigger onChanged.
        final caloriesField = find
            .descendant(
              of: find.byType(ExpandableNutrition),
              matching: find.byType(EditableText),
            )
            .at(1); // index 0 is the name field; index 1 is calories
        await tester.tap(caloriesField);
        await tester.pump();
        await tester.enterText(caloriesField, '350');
        await tester.pump();

        // The confirm dialog must appear.
        expect(find.byType(ConfirmDialog), findsOneWidget);

        // Tap the confirm button.
        await tester.tap(find.byKey(const Key('confirm-dialog-confirm')));
        await tester.pumpAndSettle();

        verify(
          () => userSettingsBloc.add(
            any(that: isA<SettingsUsualFoodPropagatedToMeals>()),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'editing nutrition on a food used by 0 meals shows no dialog and only '
      'dispatches usualFoodNutritionChanged',
      (tester) async {
        const usualFood = UsualFood(
          id: 'f2',
          name: 'Eggs',
          nutrition: Nutrition(calories: 70),
        );
        stub(
          const UserSettingsState(
            expandNutritionByDefault: true,
            usualFoods: [usualFood],
          ),
        );
        tester.view.physicalSize = const Size(1200, 3000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpPumpPumpItUP(
          deps: [userSettingsBloc],
          const UsualFoodsView(),
        );

        final caloriesField = find
            .descendant(
              of: find.byType(ExpandableNutrition),
              matching: find.byType(EditableText),
            )
            .at(1);
        await tester.tap(caloriesField);
        await tester.pump();
        await tester.enterText(caloriesField, '80');
        await tester.pump();

        // No dialog should appear.
        expect(find.byType(ConfirmDialog), findsNothing);

        verify(
          () => userSettingsBloc.add(
            any(that: isA<SettingsUsualFoodNutritionChanged>()),
          ),
        ).called(greaterThan(0));
        verifyNever(
          () => userSettingsBloc.add(
            any(that: isA<SettingsUsualFoodPropagatedToMeals>()),
          ),
        );
      },
    );
  });
}
