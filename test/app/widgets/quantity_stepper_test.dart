import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(QuantityStepper, () {
    testWidgets('steps up by a whole one with plus', (tester) async {
      double? changed;
      await tester.pumpPumpPumpItUP(
        QuantityStepper(quantity: 2, onChanged: (value) => changed = value),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(changed, equals(3));
    });

    testWidgets('steps down by a whole one with minus', (tester) async {
      double? changed;
      await tester.pumpPumpPumpItUP(
        QuantityStepper(quantity: 3, onChanged: (value) => changed = value),
      );

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(changed, equals(2));
    });

    testWidgets('minus is disabled at minQuantity', (tester) async {
      await tester.pumpPumpPumpItUP(
        QuantityStepper(quantity: 1, onChanged: (_) {}),
      );

      final stepButtons = tester.widgetList<IconButton>(
        find.byType(IconButton),
      );
      final minusButton = stepButtons.firstWhere(
        (button) => (button.icon as Icon).icon == Icons.remove,
      );
      expect(minusButton.onPressed, isNull);
    });

    testWidgets('the .1 toggle switches to tenth steps and flips its label', (
      tester,
    ) async {
      double? changed;
      await tester.pumpPumpPumpItUP(
        QuantityStepper(quantity: 2, onChanged: (value) => changed = value),
      );

      expect(find.text('.1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);

      await tester.tap(find.text('.1'));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('2.0'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(changed, closeTo(2.1, 0.0001));
    });

    testWidgets('decimal display shows the value in tenth mode', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        QuantityStepper(quantity: 2.5, onChanged: (_) {}),
      );

      await tester.tap(find.text('.1'));
      await tester.pump();

      expect(find.text('2.5'), findsOneWidget);
    });

    testWidgets('dense mode renders the stepper', (tester) async {
      await tester.pumpPumpPumpItUP(
        QuantityStepper(quantity: 1, dense: true, onChanged: (_) {}),
      );

      expect(find.byType(QuantityStepper), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);
    });
  });
}
