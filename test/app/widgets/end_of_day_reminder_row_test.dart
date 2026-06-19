import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(EndOfDayReminderRow, () {
    testWidgets('renders the daily check-in row with a time chip', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        EndOfDayReminderRow(
          mealReminder: const MealReminder(
            enabled: true,
            timeOfDay: TimeOfDay(hour: 20, minute: 0),
          ),
          onTimeChanged: (_) {},
        ),
      );

      expect(find.byType(ListTile), findsOneWidget);
      expect(find.byType(ActionChip), findsOneWidget);
    });

    testWidgets('reports a picked time through onTimeChanged', (tester) async {
      TimeOfDay? picked;
      await tester.pumpPumpPumpItUP(
        EndOfDayReminderRow(
          mealReminder: const MealReminder(
            enabled: true,
            timeOfDay: TimeOfDay(hour: 20, minute: 0),
          ),
          onTimeChanged: (value) => picked = value,
        ),
      );

      await tester.tap(find.byType(ActionChip));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(picked, equals(const TimeOfDay(hour: 20, minute: 0)));
    });

    testWidgets('ignores a cancelled time picker', (tester) async {
      var called = false;
      await tester.pumpPumpPumpItUP(
        EndOfDayReminderRow(
          mealReminder: const MealReminder(
            enabled: true,
            timeOfDay: TimeOfDay(hour: 20, minute: 0),
          ),
          onTimeChanged: (_) => called = true,
        ),
      );

      await tester.tap(find.byType(ActionChip));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(called, isFalse);
    });
  });
}
