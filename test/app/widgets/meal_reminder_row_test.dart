import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(MealReminderRow, () {
    testWidgets('shows the time chip when enabled', (tester) async {
      await tester.pumpPumpPumpItUP(
        MealReminderRow(
          mealOfTheDay: MealOfTheDay.breakfast,
          mealReminder: const MealReminder(
            enabled: true,
            timeOfDay: TimeOfDay(hour: 9, minute: 0),
          ),
          onToggled: (_) {},
          onTimeChanged: (_) {},
        ),
      );

      expect(find.text('Breakfast'), findsOneWidget);
      expect(find.byType(ActionChip), findsOneWidget);
    });

    testWidgets('shows "No reminder" when disabled', (tester) async {
      await tester.pumpPumpPumpItUP(
        MealReminderRow(
          mealOfTheDay: MealOfTheDay.lunch,
          mealReminder: const MealReminder(
            enabled: false,
            timeOfDay: TimeOfDay(hour: 14, minute: 0),
          ),
          onToggled: (_) {},
          onTimeChanged: (_) {},
        ),
      );

      expect(find.text('No reminder'), findsOneWidget);
    });

    testWidgets('reports the toggle through onToggled', (tester) async {
      bool? toggled;
      await tester.pumpPumpPumpItUP(
        MealReminderRow(
          mealOfTheDay: MealOfTheDay.breakfast,
          mealReminder: const MealReminder(
            enabled: true,
            timeOfDay: TimeOfDay(hour: 9, minute: 0),
          ),
          onToggled: (value) => toggled = value,
          onTimeChanged: (_) {},
        ),
      );

      await tester.tap(find.byType(Switch));

      expect(toggled, isFalse);
    });

    testWidgets('reports a picked time through onTimeChanged', (tester) async {
      TimeOfDay? picked;
      await tester.pumpPumpPumpItUP(
        MealReminderRow(
          mealOfTheDay: MealOfTheDay.breakfast,
          mealReminder: const MealReminder(
            enabled: true,
            timeOfDay: TimeOfDay(hour: 9, minute: 0),
          ),
          onToggled: (_) {},
          onTimeChanged: (value) => picked = value,
        ),
      );

      await tester.tap(find.byType(ActionChip));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(picked, equals(const TimeOfDay(hour: 9, minute: 0)));
    });

    testWidgets('ignores a cancelled time picker', (tester) async {
      var called = false;
      await tester.pumpPumpPumpItUP(
        MealReminderRow(
          mealOfTheDay: MealOfTheDay.breakfast,
          mealReminder: const MealReminder(
            enabled: true,
            timeOfDay: TimeOfDay(hour: 9, minute: 0),
          ),
          onToggled: (_) {},
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
