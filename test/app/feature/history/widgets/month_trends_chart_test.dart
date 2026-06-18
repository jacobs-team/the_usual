import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(MonthTrendsChart, () {
    WeightEntry weight(
      int dayOfMonth,
      double value, {
      WeightUnit weightUnit = WeightUnit.lb,
    }) {
      final loggedAt = DateTime(2026, 6, dayOfMonth, 7);
      return WeightEntry(
        id: 'w-$dayOfMonth-$value',
        loggedAt: loggedAt,
        weight: value,
        weightUnit: weightUnit,
      );
    }

    HistoryDay day(
      int dayOfMonth, {
      int? calories,
      int? protein,
      int? carbs,
      int? fat,
    }) {
      return (
        day: DateTime(2026, 6, dayOfMonth),
        nutrition: Nutrition(
          calories: calories,
          protein: protein,
          carbs: carbs,
          fat: fat,
        ),
        weightEntry: null,
        mealEntries: const <MealLogEntry>[],
      );
    }

    HistoryMonth month({
      List<HistoryDay> days = const <HistoryDay>[],
      List<WeightEntry> weightEntries = const <WeightEntry>[],
      int averageCalories = 0,
    }) {
      return (
        month: DateTime(2026, 6),
        averageNutrition: Nutrition(calories: averageCalories),
        // The widget reads days newest-first and reverses for the time axis.
        days: days,
        weightEntries: weightEntries,
      );
    }

    Future<void> pumpChart(
      WidgetTester tester, {
      required HistoryMonth monthHistory,
      double? weightGoal,
      WeightUnit weightGoalUnit = WeightUnit.lb,
      int? calorieGoal,
      ValueChanged<HistoryDay>? onDayTapped,
    }) async {
      await tester.pumpPumpPumpItUP(
        SizedBox(
          width: 360,
          height: 600,
          child: MonthTrendsChart(
            monthHistory: monthHistory,
            weightGoal: weightGoal,
            weightGoalUnit: weightGoalUnit,
            calorieGoal: calorieGoal,
            onDayTapped: onDayTapped ?? (_) {},
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('hides the card when there is no chartable data', (
      tester,
    ) async {
      await pumpChart(
        tester,
        monthHistory: month(
          days: [day(1, calories: 400)],
          weightEntries: [weight(1, 165)],
        ),
      );

      expect(find.text('WEIGHT'), findsNothing);
      expect(find.text('CALORIES'), findsNothing);
      // Neither section qualifies, so the whole card collapses to nothing.
      expect(find.byType(MonthTrendsChart), findsOneWidget);
      expect(find.byType(Divider), findsNothing);
    });

    testWidgets('renders the weight section only', (tester) async {
      await pumpChart(
        tester,
        monthHistory: month(
          days: [day(2, calories: 400)],
          weightEntries: [weight(1, 166.7), weight(5, 164.2)],
        ),
      );

      expect(find.text('WEIGHT'), findsOneWidget);
      expect(find.text('CALORIES'), findsNothing);
      // Net change down: last - first is negative.
      expect(find.textContaining('▼'), findsOneWidget);
    });

    testWidgets('renders the calories section only', (tester) async {
      await pumpChart(
        tester,
        monthHistory: month(
          // Newest first; two days with calories triggers the section.
          days: [day(5, calories: 500), day(4, calories: 300)],
          averageCalories: 400,
        ),
        calorieGoal: 2000,
      );

      expect(find.text('WEIGHT'), findsNothing);
      expect(find.text('CALORIES'), findsOneWidget);
      expect(find.text('Goal 2000'), findsOneWidget);
      expect(find.text('Avg 400'), findsOneWidget);
    });

    testWidgets('hides the calorie goal legend when no goal is set', (
      tester,
    ) async {
      await pumpChart(
        tester,
        monthHistory: month(
          days: [day(5, calories: 500), day(4, calories: 300)],
          averageCalories: 400,
        ),
      );

      expect(find.text('CALORIES'), findsOneWidget);
      expect(find.textContaining('Goal '), findsNothing);
      expect(find.text('Avg 400'), findsOneWidget);
    });

    testWidgets('renders both sections with a divider between them', (
      tester,
    ) async {
      await pumpChart(
        tester,
        monthHistory: month(
          days: [day(5, calories: 500), day(4, calories: 300)],
          weightEntries: [weight(1, 164), weight(5, 166)],
          averageCalories: 400,
        ),
        weightGoal: 160,
        calorieGoal: 1800,
      );

      expect(find.text('WEIGHT'), findsOneWidget);
      expect(find.text('CALORIES'), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
      // Net change up: last - first is positive.
      expect(find.textContaining('▲'), findsOneWidget);
    });

    testWidgets(
      'draws the goal weight line below the trend when goal is under',
      (tester) async {
        // The goal label is canvas-painted, so only the section header is a
        // Text widget. A goal under the mean weight places its label below the
        // line.
        await pumpChart(
          tester,
          monthHistory: month(
            weightEntries: [weight(1, 166), weight(5, 164)],
          ),
          weightGoal: 160,
        );

        expect(find.text('WEIGHT'), findsOneWidget);
      },
    );

    testWidgets(
      'draws the goal weight line above the trend when goal is over',
      (tester) async {
        // Goal above the mean weight pushes the label band above the line.
        await pumpChart(
          tester,
          monthHistory: month(
            weightEntries: [weight(1, 160), weight(5, 162)],
          ),
          weightGoal: 170,
        );

        expect(find.text('WEIGHT'), findsOneWidget);
      },
    );

    testWidgets('hides the goal weight line when units mismatch', (
      tester,
    ) async {
      await pumpChart(
        tester,
        monthHistory: month(
          weightEntries: [
            weight(1, 75, weightUnit: WeightUnit.kg),
            weight(5, 74, weightUnit: WeightUnit.kg),
          ],
        ),
        weightGoal: 160,
      );

      expect(find.textContaining('Goal '), findsNothing);
      expect(find.text('WEIGHT'), findsOneWidget);
    });

    testWidgets('shows no change when the net weight is flat', (tester) async {
      await pumpChart(
        tester,
        monthHistory: month(
          weightEntries: [weight(1, 165), weight(5, 165)],
        ),
      );

      expect(find.text('No change'), findsOneWidget);
    });

    testWidgets('renders a flat weight line when all weigh-ins are equal', (
      tester,
    ) async {
      // Equal weights with no goal collapse the axis range to zero, exercising
      // the centered-line branch in the painter.
      await pumpChart(
        tester,
        monthHistory: month(
          weightEntries: [weight(1, 165), weight(5, 165), weight(9, 165)],
        ),
      );

      expect(find.text('No change'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('repaints both charts when its data changes', (tester) async {
      // Hold the chart by a GlobalKey under a stable MaterialApp so the same
      // element updates in place when the data changes, running each painter's
      // shouldRepaint against the previous painter rather than remounting.
      final chartKey = GlobalKey();
      var second = false;
      late StateSetter setStep;

      HistoryMonth monthFor({required bool second}) {
        return month(
          days: second
              ? [day(5, calories: 700), day(4, calories: 350)]
              : [day(5, calories: 500), day(4, calories: 300)],
          weightEntries: second
              ? [weight(1, 170), weight(5, 168)]
              : [weight(1, 164), weight(5, 166)],
          averageCalories: second ? 525 : 400,
        );
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                setStep = setState;
                return SizedBox(
                  width: 360,
                  height: 400,
                  child: MonthTrendsChart(
                    key: chartKey,
                    monthHistory: monthFor(second: second),
                    weightGoal: 160,
                    weightGoalUnit: WeightUnit.lb,
                    calorieGoal: 1800,
                    onDayTapped: (_) {},
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Avg 400'), findsOneWidget);

      setStep(() => second = true);
      await tester.pump();

      expect(find.text('Avg 525'), findsOneWidget);
    });

    testWidgets('splits each calorie bar into macro segments', (tester) async {
      await pumpChart(
        tester,
        monthHistory: month(
          days: [
            day(5, calories: 500, protein: 30, carbs: 50, fat: 20),
            day(4, calories: 300, protein: 20, carbs: 30, fat: 10),
          ],
          averageCalories: 400,
        ),
      );

      // Rendering exercises the macro-segment painter without error.
      expect(find.byType(MonthTrendsChart), findsOneWidget);
    });

    testWidgets('tapping the calorie bars reports a day', (tester) async {
      HistoryDay? tapped;
      await pumpChart(
        tester,
        monthHistory: month(
          days: [day(5, calories: 500), day(4, calories: 300)],
          averageCalories: 400,
        ),
        onDayTapped: (historyDay) => tapped = historyDay,
      );

      await tester.tap(
        find.descendant(
          of: find.byType(MonthTrendsChart),
          matching: find.byType(GestureDetector),
        ),
      );
      await tester.pump();

      expect(tapped, isNotNull);
    });
  });
}
