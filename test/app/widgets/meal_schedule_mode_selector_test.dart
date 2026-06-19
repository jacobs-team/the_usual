import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(MealScheduleModeSelector, () {
    testWidgets('renders a segment for every mode', (tester) async {
      await tester.pumpPumpPumpItUP(
        MealScheduleModeSelector(
          mealCheckinScheduleMode: MealCheckinScheduleMode.perMeal,
          onChanged: (_) {},
        ),
      );

      final segmentedButton = tester
          .widget<SegmentedButton<MealCheckinScheduleMode>>(
            find.byType(SegmentedButton<MealCheckinScheduleMode>),
          );
      expect(
        segmentedButton.segments,
        hasLength(MealCheckinScheduleMode.values.length),
      );
    });

    testWidgets('reports the chosen mode when a segment is tapped', (
      tester,
    ) async {
      MealCheckinScheduleMode? selected;
      await tester.pumpPumpPumpItUP(
        MealScheduleModeSelector(
          mealCheckinScheduleMode: MealCheckinScheduleMode.perMeal,
          onChanged: (mode) => selected = mode,
        ),
      );

      // Each segment renders as a TextButton in values order.
      final endOfDaySegment = find
          .byType(TextButton)
          .at(MealCheckinScheduleMode.values.indexOf(
            MealCheckinScheduleMode.endOfDay,
          ));
      await tester.tap(endOfDaySegment);

      expect(selected, equals(MealCheckinScheduleMode.endOfDay));
    });
  });
}
