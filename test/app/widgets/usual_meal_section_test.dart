import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(UsualMealSection, () {
    testWidgets('renders a row per usual meal and a composer', (tester) async {
      await tester.pumpPumpPumpItUP(
        UsualMealSection(
          mealOfTheDay: MealOfTheDay.breakfast,
          usualMeals: const [
            UsualMeal(id: 'a', name: 'Eggs'),
            UsualMeal(id: 'b', name: 'Oats'),
          ],
          expandedByDefault: false,
          onAdded: (_, _) {},
          onNutritionChanged: (_, _) {},
          onRemoved: (_) {},
          onNameChanged: (id, name) {},
        ),
      );

      expect(find.text('Breakfast (2)'), findsOneWidget);
      expect(find.byType(ExpandableNutrition), findsNWidgets(2));
      expect(find.byType(UsualMealComposer), findsOneWidget);
    });

    testWidgets('forwards nutrition edits with the meal id', (tester) async {
      String? changedId;
      Nutrition? changedNutrition;
      await tester.pumpPumpPumpItUP(
        UsualMealSection(
          mealOfTheDay: MealOfTheDay.breakfast,
          usualMeals: const [UsualMeal(id: 'a', name: 'Eggs')],
          expandedByDefault: true,
          onAdded: (_, _) {},
          onNutritionChanged: (id, nutrition) {
            changedId = id;
            changedNutrition = nutrition;
          },
          onRemoved: (_) {},
          onNameChanged: (id, name) {},
        ),
      );

      await tester.enterText(find.byType(TextFormField).first, '275');

      expect(changedId, equals('a'));
      expect(changedNutrition?.calories, equals(275));
    });

    testWidgets('forwards removal with the meal id', (tester) async {
      String? removedId;
      await tester.pumpPumpPumpItUP(
        UsualMealSection(
          mealOfTheDay: MealOfTheDay.breakfast,
          usualMeals: const [UsualMeal(id: 'a', name: 'Eggs')],
          expandedByDefault: false,
          onAdded: (_, _) {},
          onNutritionChanged: (_, _) {},
          onRemoved: (id) => removedId = id,
          onNameChanged: (id, name) {},
        ),
      );

      await tester.tap(find.byIcon(Icons.delete_forever_outlined));

      expect(removedId, equals('a'));
    });

    testWidgets('forwards name edits with the meal id', (tester) async {
      String? changedId;
      String? changedName;
      await tester.pumpPumpPumpItUP(
        UsualMealSection(
          mealOfTheDay: MealOfTheDay.breakfast,
          usualMeals: const [UsualMeal(id: 'a', name: 'Eggs')],
          expandedByDefault: false,
          onAdded: (_, _) {},
          onNutritionChanged: (_, _) {},
          onRemoved: (_) {},
          onNameChanged: (id, name) {
            changedId = id;
            changedName = name;
          },
        ),
      );

      await tester.enterText(find.byType(TextField).first, 'Scrambled');

      expect(changedId, equals('a'));
      expect(changedName, equals('Scrambled'));
    });

    testWidgets('adds usual meals through the AI sheet when configured', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final mealAiRepository = MockMealAiRepository();
      when(() => mealAiRepository.isConfigured).thenReturn(true);

      String? addedName;
      Nutrition? addedNutrition;
      await tester.pumpPumpPumpItUP(
        deps: [mealAiRepository],
        UsualMealSection(
          mealOfTheDay: MealOfTheDay.breakfast,
          usualMeals: const [],
          expandedByDefault: false,
          onAdded: (name, nutrition) {
            addedName = name;
            addedNutrition = nutrition;
          },
          onNutritionChanged: (_, _) {},
          onRemoved: (_) {},
          onNameChanged: (_, _) {},
        ),
      );

      expect(find.text('Add with a photo or description'), findsOneWidget);

      await tester.tap(find.text('Add with a photo or description'));
      await tester.pumpAndSettle();
      // Scope to the sheet so the finder skips the composer field that lives
      // behind the modal.
      await tester.enterText(
        find
            .descendant(
              of: find.byType(FoodEntrySheet),
              matching: find.byType(TextFormField),
            )
            .first,
        'Burrito',
      );
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Add'));
      await tester.pumpAndSettle();

      expect(addedName, equals('Burrito'));
      expect(addedNutrition, equals(const Nutrition()));
    });

    testWidgets('cancelling the AI sheet adds nothing', (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final mealAiRepository = MockMealAiRepository();
      when(() => mealAiRepository.isConfigured).thenReturn(true);

      var addedCount = 0;
      await tester.pumpPumpPumpItUP(
        deps: [mealAiRepository],
        UsualMealSection(
          mealOfTheDay: MealOfTheDay.breakfast,
          usualMeals: const [],
          expandedByDefault: false,
          onAdded: (_, _) => addedCount++,
          onNutritionChanged: (_, _) {},
          onRemoved: (_) {},
          onNameChanged: (_, _) {},
        ),
      );

      await tester.tap(find.text('Add with a photo or description'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(addedCount, equals(0));
    });
  });
}
