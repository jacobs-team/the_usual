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

      expect(find.text(MealCheckinScheduleMode.perMeal.label), findsOneWidget);
      expect(find.text(MealCheckinScheduleMode.endOfDay.label), findsOneWidget);
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

      await tester.tap(find.text(MealCheckinScheduleMode.endOfDay.label));

      expect(selected, equals(MealCheckinScheduleMode.endOfDay));
    });
  });
}
