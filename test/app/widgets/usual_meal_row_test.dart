import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(UsualMealRow, () {
    testWidgets('renders the meal name and calorie field', (tester) async {
      await tester.pumpPumpPumpItUP(
        UsualMealRow(
          usualMeal: const UsualMeal(id: 'a', name: 'Eggs', calories: 350),
          onCaloriesChanged: (_) {},
          onRemoved: () {},
        ),
      );

      expect(find.text('Eggs'), findsOneWidget);
      expect(find.byType(CalorieField), findsOneWidget);
    });

    testWidgets('reports edited calories through onCaloriesChanged', (
      tester,
    ) async {
      int? calories;
      await tester.pumpPumpPumpItUP(
        UsualMealRow(
          usualMeal: const UsualMeal(id: 'a', name: 'Eggs'),
          onCaloriesChanged: (value) => calories = value,
          onRemoved: () {},
        ),
      );

      await tester.enterText(find.byType(TextFormField), '300');

      expect(calories, equals(300));
    });

    testWidgets('reports removal through onRemoved', (tester) async {
      var removed = false;
      await tester.pumpPumpPumpItUP(
        UsualMealRow(
          usualMeal: const UsualMeal(id: 'a', name: 'Eggs'),
          onCaloriesChanged: (_) {},
          onRemoved: () => removed = true,
        ),
      );

      await tester.tap(find.byIcon(Icons.close));

      expect(removed, isTrue);
    });
  });
}
