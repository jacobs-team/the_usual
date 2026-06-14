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

      for (final timeOfDay in WeightTimeOfDay.values) {
        expect(find.text(timeOfDay.label), findsOneWidget);
      }
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

      await tester.tap(find.text(WeightTimeOfDay.night.label));

      expect(selected, equals(WeightTimeOfDay.night));
    });
  });
}
