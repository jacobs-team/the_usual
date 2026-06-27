import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(NutritionBar, () {
    Future<void> pumpBar(
      WidgetTester tester, {
      required Nutrition nutrition,
      required int? calorieGoal,
      VoidCallback? onSetGoal,
    }) {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      return tester.pumpPumpPumpItUP(
        NutritionBar(
          nutrition: nutrition,
          calorieGoal: calorieGoal,
          onSetGoal: onSetGoal,
        ),
      );
    }

    testWidgets('shows consumed over goal and macro segments when a goal is '
        'set', (tester) async {
      await pumpBar(
        tester,
        nutrition: const Nutrition(
          calories: 500,
          protein: 30,
          carbs: 40,
          fat: 10,
        ),
        calorieGoal: 2000,
      );

      // Three colored macro segments (protein, carbs, fat) sit inside the bar.
      expect(
        find.descendant(
          of: find.byType(NutritionBar),
          matching: find.byType(ColoredBox),
        ),
        findsNWidgets(3),
      );
    });

    testWidgets('shows the set goal button and consumed calories with no '
        'goal', (tester) async {
      var tapped = false;
      await pumpBar(
        tester,
        nutrition: const Nutrition(calories: 600, protein: 20),
        calorieGoal: null,
        onSetGoal: () => tapped = true,
      );

      final setGoalButton = find.byType(TextButton);
      expect(setGoalButton, findsOneWidget);

      await tester.tap(setGoalButton);

      expect(tapped, isTrue);
    });

    testWidgets('marks the over-goal state with a red border', (tester) async {
      await pumpBar(
        tester,
        nutrition: const Nutrition(calories: 2200, protein: 50),
        calorieGoal: 2000,
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(NutritionBar),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.foregroundDecoration! as BoxDecoration;

      expect(decoration.border, isNotNull);
    });

    testWidgets('renders an empty bar when nutrition is empty', (tester) async {
      await pumpBar(
        tester,
        nutrition: const Nutrition(),
        calorieGoal: 2000,
      );

      // With no macros logged the bar has no colored segments, only the empty
      // remainder.
      expect(
        find.descendant(
          of: find.byType(NutritionBar),
          matching: find.byType(ColoredBox),
        ),
        findsNothing,
      );
    });
  });
}
