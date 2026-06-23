import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(WorkoutVolumeChart, () {
    WorkoutHistoryDay workoutHistoryDay(int dayOfMonth, double volume) {
      return (
        day: DateTime(2026, 6, dayOfMonth),
        volume: volume,
        workoutEntries: const <WorkoutLogEntry>[],
      );
    }

    WorkoutHistoryMonth workoutHistoryMonth({
      required List<WorkoutHistoryDay> days,
      double averageVolume = 0,
    }) {
      return (
        month: DateTime(2026, 6),
        averageVolume: averageVolume,
        days: days,
      );
    }

    Future<void> pumpChart(
      WidgetTester tester, {
      required WorkoutHistoryMonth monthHistory,
      ValueChanged<WorkoutHistoryDay>? onDayTapped,
    }) async {
      await tester.pumpPumpPumpItUP(
        SizedBox(
          width: 360,
          height: 300,
          child: WorkoutVolumeChart(
            monthHistory: monthHistory,
            weightUnit: WeightUnit.lb,
            onDayTapped: onDayTapped ?? (_) {},
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets(
      'renders a CustomPaint and GestureDetector for a month with 2+ volume '
      'days',
      (tester) async {
        await pumpChart(
          tester,
          monthHistory: workoutHistoryMonth(
            days: [
              workoutHistoryDay(5, 2000),
              workoutHistoryDay(4, 1500),
            ],
            averageVolume: 1750,
          ),
        );

        expect(
          find.descendant(
            of: find.byType(WorkoutVolumeChart),
            matching: find.byType(CustomPaint),
          ),
          findsWidgets,
        );
        expect(
          find.descendant(
            of: find.byType(WorkoutVolumeChart),
            matching: find.byType(GestureDetector),
          ),
          findsWidgets,
        );
      },
    );

    testWidgets('tapping the chart calls onDayTapped with a day', (
      tester,
    ) async {
      WorkoutHistoryDay? tapped;
      await pumpChart(
        tester,
        monthHistory: workoutHistoryMonth(
          days: [
            workoutHistoryDay(5, 2000),
            workoutHistoryDay(4, 1500),
          ],
          averageVolume: 1750,
        ),
        onDayTapped: (workoutHistoryDay) => tapped = workoutHistoryDay,
      );

      final tapTarget = find.descendant(
        of: find.byType(WorkoutVolumeChart),
        matching: find.byType(GestureDetector),
      );
      await tester.tap(tapTarget.first);
      await tester.pump();

      expect(tapped, isNotNull);
    });

    testWidgets(
      'renders nothing for a month with fewer than 2 days with volume',
      (tester) async {
        await pumpChart(
          tester,
          monthHistory: workoutHistoryMonth(
            days: [workoutHistoryDay(5, 1000)],
            averageVolume: 1000,
          ),
        );

        expect(
          find.descendant(
            of: find.byType(WorkoutVolumeChart),
            matching: find.byType(CustomPaint),
          ),
          findsNothing,
        );
        expect(
          find.descendant(
            of: find.byType(WorkoutVolumeChart),
            matching: find.byType(GestureDetector),
          ),
          findsNothing,
        );
      },
    );
  });
}
