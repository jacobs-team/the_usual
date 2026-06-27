import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(ExerciseStrengthChart, () {
    List<ExerciseStrengthPoint> points(List<double> estimates) => [
      for (var i = 0; i < estimates.length; i++)
        (
          sessionDay: DateTime(2026, 6, i + 1),
          estimatedOneRepMax: estimates[i],
          topSet: WorkoutSet(weight: estimates[i], reps: 1),
        ),
    ];

    Future<void> pumpChart(
      WidgetTester tester, {
      required List<ExerciseStrengthPoint> data,
      ValueChanged<ExerciseStrengthPoint>? onPointSelected,
    }) async {
      await tester.pumpPumpPumpItUP(
        SizedBox(
          width: 360,
          height: 300,
          child: ExerciseStrengthChart(
            points: data,
            weightUnit: WeightUnit.lb,
            onPointSelected: onPointSelected ?? (_) {},
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('renders a CustomPaint for 2+ points', (tester) async {
      await pumpChart(tester, data: points([120, 130]));
      expect(
        find.descendant(
          of: find.byType(ExerciseStrengthChart),
          matching: find.byType(CustomPaint),
        ),
        findsWidgets,
      );
    });

    testWidgets('renders nothing for fewer than 2 points', (tester) async {
      await pumpChart(tester, data: points([120]));
      expect(
        find.descendant(
          of: find.byType(ExerciseStrengthChart),
          matching: find.byType(CustomPaint),
        ),
        findsNothing,
      );
    });

    testWidgets('tapping selects a point', (tester) async {
      ExerciseStrengthPoint? selected;
      await pumpChart(
        tester,
        data: points([120, 130, 140]),
        onPointSelected: (point) => selected = point,
      );
      await tester.tap(
        find
            .descendant(
              of: find.byType(ExerciseStrengthChart),
              matching: find.byType(GestureDetector),
            )
            .first,
      );
      await tester.pump();
      expect(selected, isNotNull);
    });
  });
}
