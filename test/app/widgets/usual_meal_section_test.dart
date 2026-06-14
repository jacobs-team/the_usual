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
          onAdded: (_, _) {},
          onCaloriesChanged: (_, _) {},
          onRemoved: (_) {},
        ),
      );

      expect(find.text('BREAKFAST (2)'), findsOneWidget);
      expect(find.byType(UsualMealRow), findsNWidgets(2));
      expect(find.byType(UsualMealComposer), findsOneWidget);
    });

    testWidgets('forwards calorie edits with the meal id', (tester) async {
      String? changedId;
      int? changedCalories;
      await tester.pumpPumpPumpItUP(
        UsualMealSection(
          mealOfTheDay: MealOfTheDay.breakfast,
          usualMeals: const [UsualMeal(id: 'a', name: 'Eggs')],
          onAdded: (_, _) {},
          onCaloriesChanged: (id, calories) {
            changedId = id;
            changedCalories = calories;
          },
          onRemoved: (_) {},
        ),
      );

      await tester.enterText(find.byType(TextFormField).first, '275');

      expect(changedId, equals('a'));
      expect(changedCalories, equals(275));
    });

    testWidgets('forwards removal with the meal id', (tester) async {
      String? removedId;
      await tester.pumpPumpPumpItUP(
        UsualMealSection(
          mealOfTheDay: MealOfTheDay.breakfast,
          usualMeals: const [UsualMeal(id: 'a', name: 'Eggs')],
          onAdded: (_, _) {},
          onCaloriesChanged: (_, _) {},
          onRemoved: (id) => removedId = id,
        ),
      );

      await tester.tap(find.byIcon(Icons.close));

      expect(removedId, equals('a'));
    });
  });
}
