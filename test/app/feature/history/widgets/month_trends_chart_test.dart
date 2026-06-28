import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(MonthTrendsChart, () {
    // The card draws each section with a CustomPaint. Only the calorie section
    // wraps its painter in an opaque GestureDetector for bar taps, so its
    // presence distinguishes the calorie section from the weight section
    // without reading the (localizable) header copy.
    final chartPaint = find.descendant(
      of: find.byType(MonthTrendsChart),
      matching: find.byType(CustomPaint),
    );
    final calorieTapTarget = find.descendant(
      of: find.byType(MonthTrendsChart),
      matching: find.byType(GestureDetector),
    );

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
            weightGoalHistory: weightGoal == null
                ? const []
                : [
                    WeightGoalEntry(
                      effectiveFrom: DateTime.fromMillisecondsSinceEpoch(0),
                      weightUnit: weightGoalUnit,
                      weight: weightGoal,
                    ),
                  ],
            calorieGoalHistory: calorieGoal == null
                ? const []
                : [
                    CalorieGoalEntry(
                      effectiveFrom: DateTime.fromMillisecondsSinceEpoch(0),
                      calories: calorieGoal,
                    ),
                  ],
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

      // Neither section qualifies, so the card collapses: no painted chart,
      // no calorie tap target, no divider between sections.
      expect(find.byType(MonthTrendsChart), findsOneWidget);
      expect(chartPaint, findsNothing);
      expect(calorieTapTarget, findsNothing);
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

      // The weight line paints, but the calorie section (with its tap target)
      // and the both-sections divider are absent.
      expect(chartPaint, findsWidgets);
      expect(calorieTapTarget, findsNothing);
      expect(find.byType(Divider), findsNothing);
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

      // The calorie section's tap target is present and the weight-only
      // divider is absent.
      expect(calorieTapTarget, findsOneWidget);
      expect(find.byType(Divider), findsNothing);
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

      // Both sections present: a calorie tap target and the divider that only
      // appears when the weight and calorie sections sit together.
      expect(calorieTapTarget, findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets(
      'draws the goal weight line below the trend when goal is under',
      (tester) async {
        // A goal under the mean weight places its label below the line,
        // exercising that painter branch.
        await pumpChart(
          tester,
          monthHistory: month(
            weightEntries: [weight(1, 166), weight(5, 164)],
          ),
          weightGoal: 160,
        );

        expect(chartPaint, findsWidgets);
        expect(calorieTapTarget, findsNothing);
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

        expect(chartPaint, findsWidgets);
        expect(calorieTapTarget, findsNothing);
      },
    );

    testWidgets('renders the weight section when goal units mismatch', (
      tester,
    ) async {
      // A goal in a different unit than the weigh-ins is dropped, but the
      // weight line still paints.
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

      expect(chartPaint, findsWidgets);
      expect(calorieTapTarget, findsNothing);
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

      expect(chartPaint, findsWidgets);
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
                    weightGoalHistory: [
                      WeightGoalEntry(
                        effectiveFrom: DateTime.fromMillisecondsSinceEpoch(0),
                        weightUnit: WeightUnit.lb,
                        weight: 160,
                      ),
                    ],
                    calorieGoalHistory: [
                      CalorieGoalEntry(
                        effectiveFrom: DateTime.fromMillisecondsSinceEpoch(0),
                        calories: 1800,
                      ),
                    ],
                    onDayTapped: (_) {},
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(MonthTrendsChart), findsOneWidget);

      setStep(() => second = true);
      await tester.pump();

      // The same element rebuilt in place with the new data still renders both
      // painted sections and the divider between them.
      expect(find.byType(MonthTrendsChart), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets(
      'draws a stepped goal line with a gap and a goal change',
      (tester) async {
        // The first two weigh-ins predate any goal (a null gap in the stepped
        // line), then the goal applies and later changes value, so the painter
        // draws separate runs joined by a vertical connector.
        await tester.pumpPumpPumpItUP(
          SizedBox(
            width: 360,
            height: 600,
            child: MonthTrendsChart(
              monthHistory: month(
                weightEntries: [
                  weight(1, 166),
                  weight(5, 165),
                  weight(9, 164),
                  weight(13, 163),
                ],
              ),
              weightGoalHistory: [
                WeightGoalEntry(
                  effectiveFrom: DateTime(2026, 6, 7),
                  weightUnit: WeightUnit.lb,
                  weight: 160,
                ),
                WeightGoalEntry(
                  effectiveFrom: DateTime(2026, 6, 11),
                  weightUnit: WeightUnit.lb,
                  weight: 158,
                ),
              ],
              calorieGoalHistory: const [],
              onDayTapped: (_) {},
            ),
          ),
        );
        await tester.pump();

        expect(chartPaint, findsWidgets);
        expect(calorieTapTarget, findsNothing);
      },
    );

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
      expect(calorieTapTarget, findsOneWidget);
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

      await tester.tap(calorieTapTarget);
      await tester.pump();

      expect(tapped, isNotNull);
    });
  });
}
