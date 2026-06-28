import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(ExpandableWorkout, () {
    void useTallWindow(WidgetTester tester) {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    testWidgets('collapsed strength shows its sets summary', (tester) async {
      useTallWindow(tester);
      await tester.pumpPumpPumpItUP(
        ExpandableWorkout(
          name: 'Bench Press',
          sets: const [WorkoutSet(weight: 135, reps: 8)],
          weightUnit: WeightUnit.lb,
          expandedByDefault: false,
          onChanged: (_) {},
          onRemoved: () {},
        ),
      );

      expect(find.byType(ExpandableWorkout), findsOneWidget);
    });

    testWidgets('collapsed cardio with zero duration shows "No time"', (
      tester,
    ) async {
      useTallWindow(tester);
      await tester.pumpPumpPumpItUP(
        ExpandableWorkout(
          name: 'Running',
          type: WorkoutType.cardio,
          sets: const [],
          weightUnit: WeightUnit.lb,
          expandedByDefault: false,
          onChanged: (_) {},
          onRemoved: () {},
        ),
      );

      expect(find.text('No time'), findsOneWidget);
    });

    testWidgets('collapsed cardio with a duration shows its clock label', (
      tester,
    ) async {
      useTallWindow(tester);
      const duration = Duration(minutes: 30);
      await tester.pumpPumpPumpItUP(
        ExpandableWorkout(
          name: 'Running',
          type: WorkoutType.cardio,
          duration: duration,
          sets: const [],
          weightUnit: WeightUnit.lb,
          expandedByDefault: false,
          onChanged: (_) {},
          onRemoved: () {},
        ),
      );

      expect(find.text(duration.clockLabel), findsOneWidget);
    });

    testWidgets('expanded cardio shows a TimeField and its footer', (
      tester,
    ) async {
      useTallWindow(tester);
      await tester.pumpPumpPumpItUP(
        ExpandableWorkout(
          name: 'Running',
          type: WorkoutType.cardio,
          duration: const Duration(minutes: 30),
          sets: const [],
          weightUnit: WeightUnit.lb,
          expandedByDefault: true,
          onChanged: (_) {},
          onDurationChanged: (_) {},
          onRemoved: () {},
          expandedFooter: const Text('footer'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TimeField), findsOneWidget);
      expect(find.text('footer'), findsOneWidget);
    });

    testWidgets('onNameChanged makes the name an editable field', (
      tester,
    ) async {
      useTallWindow(tester);
      String? changed;
      await tester.pumpPumpPumpItUP(
        ExpandableWorkout(
          name: 'Bench Press',
          sets: const [WorkoutSet(weight: 135, reps: 8)],
          weightUnit: WeightUnit.lb,
          expandedByDefault: false,
          onChanged: (_) {},
          onRemoved: () {},
          onNameChanged: (value) => changed = value,
        ),
      );

      final field = find.byType(TheUsualTextField);
      expect(field, findsOneWidget);

      await tester.enterText(field, 'Incline Press');
      await tester.pump();

      expect(changed, equals('Incline Press'));
    });

    testWidgets('tapping the tile toggles the expansion state', (
      tester,
    ) async {
      useTallWindow(tester);
      await tester.pumpPumpPumpItUP(
        ExpandableWorkout(
          name: 'Bench Press',
          sets: const [WorkoutSet(weight: 135, reps: 8)],
          weightUnit: WeightUnit.lb,
          expandedByDefault: false,
          onChanged: (_) {},
          onRemoved: () {},
        ),
      );

      await tester.tap(find.byType(ExpansionTile));
      await tester.pumpAndSettle();

      expect(find.byType(SetFields), findsOneWidget);
    });

    testWidgets('tapping remove calls onRemoved', (tester) async {
      useTallWindow(tester);
      var removed = false;
      await tester.pumpPumpPumpItUP(
        ExpandableWorkout(
          name: 'Bench Press',
          sets: const [WorkoutSet(weight: 135, reps: 8)],
          weightUnit: WeightUnit.lb,
          expandedByDefault: false,
          onChanged: (_) {},
          onRemoved: () => removed = true,
        ),
      );

      await tester.tap(find.byIcon(Icons.delete_forever_outlined));
      await tester.pump();

      expect(removed, isTrue);
    });

    testWidgets('an externally changed name updates the editable field', (
      tester,
    ) async {
      useTallWindow(tester);
      const key = Key('expandable');
      Widget build(String name) {
        return ExpandableWorkout(
          key: key,
          name: name,
          sets: const [WorkoutSet(weight: 135, reps: 8)],
          weightUnit: WeightUnit.lb,
          expandedByDefault: false,
          onChanged: (_) {},
          onRemoved: () {},
          onNameChanged: (_) {},
        );
      }

      await tester.pumpPumpPumpItUP(build('Bench Press'));
      await tester.pumpPumpPumpItUP(build('Overhead Press'));
      await tester.pump();

      final field = tester.widget<TheUsualTextField>(
        find.byType(TheUsualTextField),
      );
      expect(field.controller?.text, equals('Overhead Press'));
    });

    testWidgets('flipping expandedByDefault expands the tile', (tester) async {
      useTallWindow(tester);
      const key = Key('expandable');
      Widget build({required bool expanded}) {
        return ExpandableWorkout(
          key: key,
          name: 'Bench Press',
          sets: const [WorkoutSet(weight: 135, reps: 8)],
          weightUnit: WeightUnit.lb,
          expandedByDefault: expanded,
          onChanged: (_) {},
          onRemoved: () {},
        );
      }

      await tester.pumpPumpPumpItUP(build(expanded: false));
      await tester.pumpPumpPumpItUP(build(expanded: true));
      await tester.pumpAndSettle();

      expect(find.byType(SetFields), findsOneWidget);
    });

    testWidgets('flipping expandedByDefault to false collapses the tile', (
      tester,
    ) async {
      useTallWindow(tester);
      const key = Key('expandable');
      Widget build({required bool expanded}) {
        return ExpandableWorkout(
          key: key,
          name: 'Bench Press',
          sets: const [WorkoutSet(weight: 135, reps: 8)],
          weightUnit: WeightUnit.lb,
          expandedByDefault: expanded,
          onChanged: (_) {},
          onRemoved: () {},
        );
      }

      await tester.pumpPumpPumpItUP(build(expanded: true));
      await tester.pumpAndSettle();
      await tester.pumpPumpPumpItUP(build(expanded: false));
      await tester.pumpAndSettle();

      expect(find.byType(ExpandableWorkout), findsOneWidget);
    });
  });
}
