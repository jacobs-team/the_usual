import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(WeightCheckinFrequencyChips, () {
    testWidgets('renders a chip for every frequency', (tester) async {
      await tester.pumpPumpPumpItUP(
        WeightCheckinFrequencyChips(
          selected: WeightCheckinFrequency.daily,
          onSelected: (_) {},
        ),
      );

      expect(
        find.byType(ChoiceChip),
        findsNWidgets(WeightCheckinFrequency.values.length),
      );
    });

    testWidgets('reports the chosen frequency when a chip is tapped', (
      tester,
    ) async {
      WeightCheckinFrequency? selected;
      await tester.pumpPumpPumpItUP(
        WeightCheckinFrequencyChips(
          selected: WeightCheckinFrequency.daily,
          onSelected: (value) => selected = value,
        ),
      );

      // Chips render in WeightCheckinFrequency.values order.
      final weeklyChip = find
          .byType(ChoiceChip)
          .at(WeightCheckinFrequency.values.indexOf(
            WeightCheckinFrequency.weekly,
          ));
      await tester.tap(weeklyChip);

      expect(selected, equals(WeightCheckinFrequency.weekly));
    });
  });
}
