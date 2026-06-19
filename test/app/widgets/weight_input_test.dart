import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(WeightInput, () {
    testWidgets('renders a chip for each unit', (tester) async {
      await tester.pumpPumpPumpItUP(
        WeightInput(
          controller: TextEditingController(),
          weightUnit: WeightUnit.lb,
          onWeightChanged: (_) {},
          onUnitSelected: (_) {},
        ),
      );

      expect(
        find.byType(ChoiceChip),
        findsNWidgets(WeightUnit.values.length),
      );
    });

    testWidgets('parses entered text into a weight', (tester) async {
      double? weight;
      await tester.pumpPumpPumpItUP(
        WeightInput(
          controller: TextEditingController(),
          weightUnit: WeightUnit.lb,
          onWeightChanged: (value) => weight = value,
          onUnitSelected: (_) {},
        ),
      );

      await tester.enterText(find.byType(TextFormField), '165.5');

      expect(weight, equals(165.5));
    });

    testWidgets('reports the chosen unit when a chip is tapped', (
      tester,
    ) async {
      WeightUnit? unit;
      await tester.pumpPumpPumpItUP(
        WeightInput(
          controller: TextEditingController(),
          weightUnit: WeightUnit.lb,
          onWeightChanged: (_) {},
          onUnitSelected: (value) => unit = value,
        ),
      );

      // Chips render in WeightUnit.values order, so kg is the second chip.
      final kgIndex = WeightUnit.values.indexOf(WeightUnit.kg);
      await tester.tap(find.byType(ChoiceChip).at(kgIndex));

      expect(unit, equals(WeightUnit.kg));
    });
  });
}
