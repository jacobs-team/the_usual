import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(WeightTimeOfDayChips, () {
    testWidgets('renders a chip for every time of day', (tester) async {
      await tester.pumpPumpPumpItUP(
        WeightTimeOfDayChips(
          selected: WeightTimeOfDay.morning,
          onSelected: (_) {},
        ),
      );

      expect(
        find.byType(ChoiceChip),
        findsNWidgets(WeightTimeOfDay.values.length),
      );
    });

    testWidgets('reports the chosen time of day when a chip is tapped', (
      tester,
    ) async {
      WeightTimeOfDay? selected;
      await tester.pumpPumpPumpItUP(
        WeightTimeOfDayChips(
          selected: WeightTimeOfDay.morning,
          onSelected: (value) => selected = value,
        ),
      );

      // Chips render in WeightTimeOfDay.values order.
      final nightChip = find
          .byType(ChoiceChip)
          .at(WeightTimeOfDay.values.indexOf(WeightTimeOfDay.night));
      await tester.tap(nightChip);

      expect(selected, equals(WeightTimeOfDay.night));
    });
  });
}
