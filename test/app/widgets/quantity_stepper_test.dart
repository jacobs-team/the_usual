import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(QuantityStepper, () {
    // The step-size toggle is the stepper's only OutlinedButton; its label
    // ('.1' / '1') is copy, so locate it by type rather than text.
    Finder toggle() => find.descendant(
      of: find.byType(QuantityStepper),
      matching: find.byType(OutlinedButton),
    );

    // The value sits in a Text that isn't part of the toggle button.
    String valueLabel(WidgetTester tester) {
      final valueText = find.descendant(
        of: find.byType(QuantityStepper),
        matching: find.byType(Text),
      );
      for (final element in valueText.evaluate()) {
        final isInsideToggle = element
            .findAncestorWidgetOfExactType<OutlinedButton>();
        if (isInsideToggle == null) {
          return (element.widget as Text).data!;
        }
      }
      throw StateError('no value label found');
    }

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

      expect(valueLabel(tester), equals('2'));

      await tester.tap(toggle());
      await tester.pump();

      expect(valueLabel(tester), equals('2.0'));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(changed, closeTo(2.1, 0.0001));
    });

    testWidgets('tenth steps emit a value free of floating-point dust', (
      tester,
    ) async {
      double? changed;
      await tester.pumpPumpPumpItUP(
        QuantityStepper(quantity: 2.2, onChanged: (value) => changed = value),
      );

      await tester.tap(toggle());
      await tester.pump();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(changed, equals(2.3));
    });

    testWidgets('decimal display shows the value in tenth mode', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        QuantityStepper(quantity: 2.5, onChanged: (_) {}),
      );

      await tester.tap(toggle());
      await tester.pump();

      expect(valueLabel(tester), equals('2.5'));
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
