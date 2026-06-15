import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
        ),
      );

      await tester.tap(find.byIcon(Icons.remove));

      expect(removedId, equals('a'));
    });
  });
}
