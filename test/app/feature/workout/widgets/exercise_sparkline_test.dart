import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(ExerciseSparkline, () {
    testWidgets('paints for 2+ values', (tester) async {
      await tester.pumpPumpPumpItUP(
        const SizedBox(
          width: 80,
          height: 24,
          child: ExerciseSparkline(values: [120, 130, 128, 140]),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(ExerciseSparkline),
          matching: find.byType(CustomPaint),
        ),
        findsWidgets,
      );
    });

    testWidgets('renders nothing for fewer than 2 values', (tester) async {
      await tester.pumpPumpPumpItUP(
        const SizedBox(
          width: 80,
          height: 24,
          child: ExerciseSparkline(values: [120]),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(ExerciseSparkline),
          matching: find.byType(CustomPaint),
        ),
        findsNothing,
      );
    });
  });
}
