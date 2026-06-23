import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(ExpandableWorkout, () {
    const testSets = [
      WorkoutSet(weight: 100, reps: 8),
      WorkoutSet(weight: 100, reps: 6),
    ];

    testWidgets('collapsed shows the sets summary text', (tester) async {
      await tester.pumpPumpPumpItUP(
        ExpandableWorkout(
          name: 'Bench Press',
          sets: testSets,
          weightUnit: WeightUnit.kg,
          expandedByDefault: false,
          onChanged: (_) {},
          onRemoved: () {},
        ),
      );

      final summaryShown = tester
          .widgetList<Text>(find.byType(Text))
          .any((text) => text.data == testSets.summary);
      expect(summaryShown, isTrue);
    });

    testWidgets('tapping delete calls onRemoved', (tester) async {
      var removed = false;
      await tester.pumpPumpPumpItUP(
        ExpandableWorkout(
          name: 'Bench Press',
          sets: testSets,
          weightUnit: WeightUnit.kg,
          expandedByDefault: false,
          onChanged: (_) {},
          onRemoved: () => removed = true,
        ),
      );

      await tester.tap(find.byIcon(Icons.delete_forever_outlined));

      expect(removed, isTrue);
    });

    testWidgets('when expandedByDefault is true, SetFields is shown', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        ExpandableWorkout(
          name: 'Bench Press',
          sets: testSets,
          weightUnit: WeightUnit.kg,
          expandedByDefault: true,
          onChanged: (_) {},
          onRemoved: () {},
        ),
      );

      expect(find.byType(SetFields), findsOneWidget);
    });

    testWidgets('editing in SetFields propagates through onChanged', (
      tester,
    ) async {
      List<WorkoutSet>? changedSets;
      await tester.pumpPumpPumpItUP(
        ExpandableWorkout(
          name: 'Bench Press',
          sets: const [WorkoutSet()],
          weightUnit: WeightUnit.kg,
          expandedByDefault: true,
          onChanged: (sets) => changedSets = sets,
          onRemoved: () {},
        ),
      );

      await tester.enterText(find.byKey(const Key('set-weight-0')), '120');
      await tester.pump();

      expect(changedSets, isNotNull);
      expect(
        changedSets!.first.weight,
        equals(120),
      );
    });

    testWidgets('removes the entry when the trailing button is pressed', (
      tester,
    ) async {
      var removed = false;
      await tester.pumpPumpPumpItUP(
        ExpandableWorkout(
          name: 'Squat',
          sets: testSets,
          weightUnit: WeightUnit.kg,
          expandedByDefault: false,
          onChanged: (_) {},
          onRemoved: () => removed = true,
        ),
      );

      await tester.tap(find.byIcon(Icons.delete_forever_outlined));

      expect(removed, isTrue);
    });

    testWidgets('shows the expanded footer while expanded', (tester) async {
      await tester.pumpPumpPumpItUP(
        ExpandableWorkout(
          name: 'Deadlift',
          sets: testSets,
          weightUnit: WeightUnit.kg,
          expandedByDefault: true,
          onChanged: (_) {},
          onRemoved: () {},
          expandedFooter: const SizedBox(key: Key('expanded-footer')),
        ),
      );

      expect(find.byKey(const Key('expanded-footer')), findsOneWidget);
    });

    testWidgets('forwards name edits when onNameChanged is provided', (
      tester,
    ) async {
      String? changedName;
      await tester.pumpPumpPumpItUP(
        ExpandableWorkout(
          name: 'Bench Press',
          sets: testSets,
          weightUnit: WeightUnit.kg,
          expandedByDefault: false,
          onChanged: (_) {},
          onNameChanged: (name) => changedName = name,
          onRemoved: () {},
        ),
      );

      await tester.enterText(find.byType(TextField).first, 'Incline Press');

      expect(changedName, equals('Incline Press'));
    });

    testWidgets('reflects an externally changed name', (tester) async {
      late void Function(void Function()) rebuild;
      var name = 'Bench Press';
      await tester.pumpPumpPumpItUP(
        StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            return ExpandableWorkout(
              name: name,
              sets: testSets,
              weightUnit: WeightUnit.kg,
              expandedByDefault: false,
              onChanged: (_) {},
              onNameChanged: (_) {},
              onRemoved: () {},
            );
          },
        ),
      );

      rebuild(() => name = 'Squat');
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField).first);
      expect(textField.controller?.text, equals('Squat'));
    });

    testWidgets('follows expandedByDefault when it flips', (tester) async {
      late void Function(void Function()) rebuild;
      var expanded = false;
      await tester.pumpPumpPumpItUP(
        StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            return ExpandableWorkout(
              name: 'Bench Press',
              sets: testSets,
              weightUnit: WeightUnit.kg,
              expandedByDefault: expanded,
              onChanged: (_) {},
              onRemoved: () {},
            );
          },
        ),
      );

      expect(find.byType(SetFields), findsNothing);

      rebuild(() => expanded = true);
      await tester.pumpAndSettle();
      expect(find.byType(SetFields), findsOneWidget);

      rebuild(() => expanded = false);
      await tester.pumpAndSettle();
      expect(find.byType(SetFields), findsNothing);
    });
  });
}
