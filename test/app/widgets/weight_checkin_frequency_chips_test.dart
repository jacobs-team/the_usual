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

      for (final frequency in WeightCheckinFrequency.values) {
        expect(find.text(frequency.label), findsOneWidget);
      }
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

      await tester.tap(find.text(WeightCheckinFrequency.weekly.label));

      expect(selected, equals(WeightCheckinFrequency.weekly));
    });
  });
}
