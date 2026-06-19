import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(ExpandableNutrition, () {
    // The collapsed name lives in the tile's title Text (rendered only when
    // onNameChanged is null). Reading its data lets us assert the ×N prefix
    // without matching on copy.
    String titleText(WidgetTester tester) => tester.widget<Text>(
      find
          .descendant(
            of: find.byType(ExpansionTile),
            matching: find.byType(Text),
          )
          .first,
    ).data!;

    testWidgets('collapsed shows a read-only summary, expanded reveals the '
        'fields', (tester) async {
      await tester.pumpPumpPumpItUP(
        ExpandableNutrition(
          name: 'Eggs',
          nutrition: const Nutrition(calories: 200),
          expandedByDefault: false,
          onChanged: (_) {},
          onRemoved: () {},
        ),
      );

      expect(find.byType(NutritionSummary), findsOneWidget);
      expect(find.byType(NutritionFields), findsNothing);

      await tester.tap(find.byType(ExpansionTile));
      await tester.pumpAndSettle();

      expect(find.byType(NutritionFields), findsOneWidget);
    });

    testWidgets('forwards name edits when onNameChanged is provided', (
      tester,
    ) async {
      String? changedName;
      await tester.pumpPumpPumpItUP(
        ExpandableNutrition(
          name: 'Eggs',
          nutrition: const Nutrition(),
          expandedByDefault: false,
          onChanged: (_) {},
          onNameChanged: (name) => changedName = name,
          onRemoved: () {},
        ),
      );

      await tester.enterText(find.byType(TextField).first, 'Scrambled eggs');

      expect(changedName, equals('Scrambled eggs'));
    });

    testWidgets('shows the quantity stepper and steps it', (tester) async {
      double? changedQuantity;
      await tester.pumpPumpPumpItUP(
        ExpandableNutrition(
          name: 'Eggs',
          nutrition: const Nutrition(calories: 100),
          expandedByDefault: true,
          quantity: 2,
          onQuantityChanged: (quantity) => changedQuantity = quantity,
          onChanged: (_) {},
          onRemoved: () {},
        ),
      );

      expect(find.byType(QuantityStepper), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));

      expect(changedQuantity, equals(3));
    });

    testWidgets('shows a scaled summary when quantity is over one', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        ExpandableNutrition(
          name: 'Eggs',
          nutrition: const Nutrition(calories: 100),
          expandedByDefault: true,
          quantity: 3,
          onQuantityChanged: (_) {},
          onChanged: (_) {},
          onRemoved: () {},
        ),
      );

      // While expanded with a quantity over one the scaled-summary row shows
      // the per-unit nutrition multiplied by the quantity.
      final scaledSummary = tester.widget<NutritionSummary>(
        find.byType(NutritionSummary),
      );
      expect(scaledSummary.nutrition.calories, equals(300));
    });

    testWidgets('shows the ×N prefix on the collapsed name', (tester) async {
      await tester.pumpPumpPumpItUP(
        ExpandableNutrition(
          name: 'Eggs',
          nutrition: const Nutrition(calories: 100),
          expandedByDefault: false,
          quantity: 2,
          onQuantityChanged: (_) {},
          onChanged: (_) {},
          onRemoved: () {},
        ),
      );

      expect(titleText(tester), equals('×2 Eggs'));
    });

    testWidgets('shows the ×N prefix for a fractional quantity', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        ExpandableNutrition(
          name: 'Eggs',
          nutrition: const Nutrition(calories: 100),
          expandedByDefault: false,
          quantity: 0.5,
          onQuantityChanged: (_) {},
          onChanged: (_) {},
          onRemoved: () {},
        ),
      );

      expect(titleText(tester), equals('×0.5 Eggs'));
    });

    testWidgets('reflects an externally changed name', (tester) async {
      late void Function(void Function()) rebuild;
      var name = 'Eggs';
      await tester.pumpPumpPumpItUP(
        StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            return ExpandableNutrition(
              name: name,
              nutrition: const Nutrition(),
              expandedByDefault: false,
              onChanged: (_) {},
              onNameChanged: (_) {},
              onRemoved: () {},
            );
          },
        ),
      );

      rebuild(() => name = 'Oatmeal');
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField).first);

      expect(textField.controller?.text, equals('Oatmeal'));
    });

    testWidgets('follows expandedByDefault when it flips', (tester) async {
      late void Function(void Function()) rebuild;
      var expanded = false;
      await tester.pumpPumpPumpItUP(
        StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            return ExpandableNutrition(
              name: 'Eggs',
              nutrition: const Nutrition(calories: 100),
              expandedByDefault: expanded,
              onChanged: (_) {},
              onRemoved: () {},
            );
          },
        ),
      );

      expect(find.byType(NutritionFields), findsNothing);

      rebuild(() => expanded = true);
      await tester.pumpAndSettle();
      expect(find.byType(NutritionFields), findsOneWidget);

      rebuild(() => expanded = false);
      await tester.pumpAndSettle();
      expect(find.byType(NutritionFields), findsNothing);
    });

    testWidgets('removes the entry when the trailing button is pressed', (
      tester,
    ) async {
      var removed = false;
      await tester.pumpPumpPumpItUP(
        ExpandableNutrition(
          name: 'Eggs',
          nutrition: const Nutrition(),
          expandedByDefault: false,
          onChanged: (_) {},
          onRemoved: () => removed = true,
        ),
      );

      await tester.tap(find.byIcon(Icons.delete_forever_outlined));

      expect(removed, isTrue);
    });

    testWidgets('shows the expanded footer while expanded', (tester) async {
      await tester.pumpPumpPumpItUP(
        ExpandableNutrition(
          name: 'Eggs',
          nutrition: const Nutrition(),
          expandedByDefault: true,
          onChanged: (_) {},
          onRemoved: () {},
          expandedFooter: const SizedBox(key: Key('expanded-footer')),
        ),
      );

      expect(find.byKey(const Key('expanded-footer')), findsOneWidget);
    });
  });
}
