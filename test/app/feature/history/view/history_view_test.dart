import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(HistoryView, () {
    late DailyLogBloc dailyLogBloc;

    // The month strip is the only horizontally scrolling list, so it anchors
    // the month chips without reading their (localized) labels.
    final monthStrip = find.byWidgetPredicate(
      (widget) =>
          widget is SingleChildScrollView &&
          widget.scrollDirection == Axis.horizontal,
    );
    final monthChips = find.descendant(
      of: monthStrip,
      matching: find.byType(InkWell),
    );

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
        nutrition: Nutrition(calories: calories),
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

      // The empty branch shows neither the month strip nor any month pages.
      expect(monthStrip, findsNothing);
      expect(find.byType(PageView), findsNothing);
    });

    testWidgets('renders the month selector and day cards', (tester) async {
      useTallWindow(tester);
      stub(twoMonthState());
      await tester.pumpPumpPumpItUP(
        deps: [dailyLogBloc],
        const HistoryView(),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TheUsualAppBar), findsOneWidget);
      expect(monthStrip, findsOneWidget);
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

      // Day cards start collapsed, so no meal rows are shown yet.
      expect(find.byType(LoggedEntryRow), findsNothing);

      await tester.tap(find.byType(ExpansionTile).first);
      await tester.pumpAndSettle();

      expect(find.byType(LoggedEntryRow), findsWidgets);
    });

    testWidgets('shows every meal with an add button on a day', (
      tester,
    ) async {
      useTallWindow(tester);
      stub(
        DailyLogState(
          mealEntries: [
            MealLogEntry(
              id: 'a',
              loggedAt: DateTime(2026, 6, 16, 19),
              mealOfTheDay: MealOfTheDay.dinner,
              name: 'Tacos',
              nutrition: const Nutrition(calories: 650),
            ),
          ],
        ),
      );
      await tester.pumpPumpPumpItUP(
        deps: [dailyLogBloc],
        const HistoryView(),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ExpansionTile).first);
      await tester.pumpAndSettle();

      // One add button per meal of the day.
      expect(find.byIcon(Icons.add), findsNWidgets(MealOfTheDay.values.length));
    });

    testWidgets('tapping a meal add button opens the meal sheet', (
      tester,
    ) async {
      useTallWindow(tester);
      stub(
        DailyLogState(
          mealEntries: [
            MealLogEntry(
              id: 'a',
              loggedAt: DateTime(2026, 6, 16, 19),
              mealOfTheDay: MealOfTheDay.dinner,
              name: 'Tacos',
              nutrition: const Nutrition(calories: 650),
            ),
          ],
        ),
      );
      await tester.pumpPumpPumpItUP(
        deps: [dailyLogBloc],
        const HistoryView(),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ExpansionTile).first);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pumpAndSettle();

      expect(find.byType(HistoryMealSheet), findsOneWidget);
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
      await tester.tap(monthChips.first);
      await tester.pumpAndSettle();

      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets(
      'clamps to a remaining month when the selected one is deleted',
      (tester) async {
        useTallWindow(tester);

        // Start on the latest month (June), then emit a state where June's only
        // entries are gone, leaving May. The selected month vanishes, so the
        // post-frame clamp snaps the selection back into range.
        final stateController = StreamController<DailyLogState>.broadcast();
        addTearDown(stateController.close);
        var currentState = twoMonthState();
        when(() => dailyLogBloc.state).thenAnswer((_) => currentState);
        when(
          () => dailyLogBloc.stream,
        ).thenAnswer((_) => stateController.stream);

        await tester.pumpPumpPumpItUP(
          deps: [dailyLogBloc],
          const HistoryView(),
        );
        await tester.pumpAndSettle();

        // Two months logged, so two chips in the strip.
        expect(monthChips, findsNWidgets(2));

        final mayOnlyState = DailyLogState(
          mealEntries: [meal(DateTime(2026, 5, 10, 8), calories: 300)],
        );
        currentState = mayOnlyState;
        stateController.add(mayOnlyState);
        await tester.pumpAndSettle();

        // The deleted month drops out of the strip, leaving one chip, and the
        // page view stays mounted rather than crashing on the gone selection.
        expect(monthChips, findsOneWidget);
        expect(find.byType(PageView), findsOneWidget);
      },
    );

    testWidgets('tapping a calorie bar scrolls to and expands that day', (
      tester,
    ) async {
      useTallWindow(tester);
      // Two days with calories so the calorie chart (and its bars) render.
      stub(
        DailyLogState(
          mealEntries: [
            meal(DateTime(2026, 6, 10, 8), calories: 400),
            meal(DateTime(2026, 6, 14, 8), calories: 500),
          ],
        ),
      );
      await tester.pumpPumpPumpItUP(deps: [dailyLogBloc], const HistoryView());
      await tester.pumpAndSettle();

      expect(find.byType(MonthTrendsChart), findsOneWidget);
      // Day cards start collapsed, so no meal rows are shown yet.
      expect(find.byType(LoggedEntryRow), findsNothing);

      await tester.tap(
        find.descendant(
          of: find.byType(MonthTrendsChart),
          matching: find.byType(GestureDetector),
        ),
      );
      await tester.pumpAndSettle();

      // The tapped day scrolled into view and expanded, revealing its meals.
      expect(find.byType(LoggedEntryRow), findsWidgets);
    });
  });
}
