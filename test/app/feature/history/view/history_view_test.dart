import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(HistoryView, () {
    late DailyLogBloc dailyLogBloc;

    void stub(DailyLogState state) {
      when(() => dailyLogBloc.state).thenReturn(state);
      when(() => dailyLogBloc.stream).thenAnswer((_) => const Stream.empty());
    }

    setUp(() {
      dailyLogBloc = MockDailyLogBloc();
    });

    MealLogEntry meal(DateTime day, {int? calories}) {
      return MealLogEntry(
        id: 'm-${day.millisecondsSinceEpoch}-$calories',
        loggedAt: day,
        mealOfTheDay: MealOfTheDay.breakfast,
        name: 'Eggs',
        calories: calories,
      );
    }

    DailyLogState twoMonthState() {
      return DailyLogState(
        mealEntries: [
          meal(DateTime(2026, 5, 10, 8), calories: 300),
          meal(DateTime(2026, 6, 14, 8), calories: 500),
          meal(DateTime(2026, 6, 14, 13)),
        ],
        weightEntries: [
          WeightEntry(
            id: 'w',
            loggedAt: DateTime(2026, 6, 14, 7),
            weight: 165,
            weightUnit: WeightUnit.lb,
          ),
        ],
      );
    }

    void useTallWindow(WidgetTester tester) {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    testWidgets('shows an empty state when nothing is logged', (tester) async {
      stub(const DailyLogState());
      await tester.pumpPumpPumpItUP(
        deps: [dailyLogBloc],
        const HistoryView(),
      );

      expect(find.textContaining('No history yet'), findsOneWidget);
    });

    testWidgets('renders the month selector and day cards', (tester) async {
      useTallWindow(tester);
      stub(twoMonthState());
      await tester.pumpPumpPumpItUP(
        deps: [dailyLogBloc],
        const HistoryView(),
      );
      await tester.pumpAndSettle();

      expect(find.text('History'), findsOneWidget);
      expect(find.byType(ExpansionTile), findsWidgets);
    });

    testWidgets('expands a day to show its meals', (tester) async {
      useTallWindow(tester);
      stub(twoMonthState());
      await tester.pumpPumpPumpItUP(
        deps: [dailyLogBloc],
        const HistoryView(),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ExpansionTile).first);
      await tester.pumpAndSettle();

      expect(find.text('Eggs'), findsWidgets);
    });

    testWidgets('selecting a month chip flips the page', (tester) async {
      useTallWindow(tester);
      stub(twoMonthState());
      await tester.pumpPumpPumpItUP(
        deps: [dailyLogBloc],
        const HistoryView(),
      );
      await tester.pumpAndSettle();

      // The earliest month is first in the strip; tap it to flip back.
      await tester.tap(find.text('MAY'));
      await tester.pumpAndSettle();

      expect(find.byType(PageView), findsOneWidget);
    });
  });
}
