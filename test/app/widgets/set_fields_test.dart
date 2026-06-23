import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(SetFields, () {
    testWidgets('renders one row per initial set', (tester) async {
      await tester.pumpPumpPumpItUP(
        SetFields(
          initial: const [
            WorkoutSet(weight: 135, reps: 8),
            WorkoutSet(weight: 145, reps: 6),
          ],
          weightUnit: WeightUnit.lb,
          onChanged: (_) {},
        ),
      );

      expect(find.byKey(const Key('set-weight-0')), findsOneWidget);
      expect(find.byKey(const Key('set-weight-1')), findsOneWidget);
      expect(find.byKey(const Key('set-weight-2')), findsNothing);
    });

    testWidgets('typing a weight and reps emits parsed values', (tester) async {
      List<WorkoutSet>? emitted;
      await tester.pumpPumpPumpItUP(
        SetFields(
          initial: const [WorkoutSet()],
          weightUnit: WeightUnit.lb,
          onChanged: (sets) => emitted = sets,
        ),
      );

      await tester.enterText(find.byKey(const Key('set-weight-0')), '135');
      expect(emitted, isNotNull);
      expect(emitted!.first.weight, equals(135.0));

      await tester.enterText(find.byKey(const Key('set-reps-0')), '8');
      expect(emitted!.first.reps, equals(8));
    });

    testWidgets('emits an added set when Add set is tapped', (tester) async {
      List<WorkoutSet>? emitted;
      await tester.pumpPumpPumpItUP(
        SetFields(
          initial: const [WorkoutSet(weight: 135, reps: 8)],
          weightUnit: WeightUnit.lb,
          onChanged: (sets) => emitted = sets,
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(emitted, isNotNull);
      expect(emitted, hasLength(2));
    });

    testWidgets('removes a row and hides remove when one remains', (
      tester,
    ) async {
      List<WorkoutSet>? emitted;
      await tester.pumpPumpPumpItUP(
        SetFields(
          initial: const [
            WorkoutSet(weight: 135, reps: 8),
            WorkoutSet(weight: 145, reps: 6),
          ],
          weightUnit: WeightUnit.lb,
          onChanged: (sets) => emitted = sets,
        ),
      );

      expect(find.byIcon(Icons.close), findsNWidgets(2));
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pump();
      expect(emitted, hasLength(1));
      await tester.pump();
      expect(find.byIcon(Icons.close), findsNothing);
    });
  });
}
