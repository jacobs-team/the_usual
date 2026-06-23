import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(WorkoutEntrySheet, () {
    /// Opens the sheet from a button and records whatever it pops with.
    Future<List<WorkoutEntryResult?>> showSheet(
      WidgetTester tester, {
      bool showAddToUsuals = false,
    }) async {
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final results = <WorkoutEntryResult?>[];
      await tester.pumpPumpPumpItUP(
        Builder(
          builder: (context) => ElevatedButton(
            key: const Key('open-sheet-button'),
            onPressed: () async {
              final result = await showModalBottomSheet<WorkoutEntryResult>(
                context: context,
                builder: (_) => WorkoutEntrySheet(
                  title: 'New workout',
                  confirmLabel: 'Log',
                  weightUnit: WeightUnit.kg,
                  showAddToUsuals: showAddToUsuals,
                ),
              );
              results.add(result);
            },
            child: const Text('open'),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('open-sheet-button')));
      await tester.pumpAndSettle();
      return results;
    }

    testWidgets('confirm is disabled until a name is entered', (tester) async {
      await showSheet(tester);

      final confirmBefore = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );
      expect(confirmBefore.onPressed, isNull);

      await tester.enterText(find.byType(TextFormField).first, 'Bench Press');
      await tester.pump();

      final confirmAfter = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );
      expect(confirmAfter.onPressed, isNotNull);
    });

    testWidgets('confirming pops with a WorkoutEntryResult carrying the name',
        (tester) async {
      WorkoutEntryResult? popped;
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpPumpPumpItUP(
        Builder(
          builder: (context) => ElevatedButton(
            key: const Key('open-sheet-button'),
            onPressed: () async {
              popped = await showModalBottomSheet<WorkoutEntryResult>(
                context: context,
                builder: (_) => const WorkoutEntrySheet(
                  title: 'New workout',
                  confirmLabel: 'Log',
                  weightUnit: WeightUnit.kg,
                ),
              );
            },
            child: const Text('open'),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('open-sheet-button')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'Squat');
      await tester.pump();
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(popped, isNotNull);
      expect(popped!.name, equals('Squat'));
      expect(popped!.sets, isA<List<WorkoutSet>>());
    });

    testWidgets('the save-as-usual checkbox appears only when showAddToUsuals',
        (tester) async {
      await showSheet(tester, showAddToUsuals: false);
      expect(find.byType(Checkbox), findsNothing);

      // Reopen with showAddToUsuals: true — need a fresh pump.
    });

    testWidgets('the save-as-usual checkbox is shown when showAddToUsuals true',
        (tester) async {
      await showSheet(tester, showAddToUsuals: true);
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('addToUsuals is false by default in the popped result',
        (tester) async {
      final results = await showSheet(tester, showAddToUsuals: true);

      await tester.enterText(find.byType(TextFormField).first, 'Deadlift');
      await tester.pump();
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(results.single, isNotNull);
      expect(results.single!.addToUsuals, isFalse);
    });

    testWidgets('toggling the checkbox flips addToUsuals in the result',
        (tester) async {
      final results = await showSheet(tester, showAddToUsuals: true);

      await tester.enterText(find.byType(TextFormField).first, 'Deadlift');
      await tester.pump();
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(results.single, isNotNull);
      expect(results.single!.addToUsuals, isTrue);
    });

    testWidgets('the close button pops with null', (tester) async {
      final results = await showSheet(tester);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(results.single, isNull);
    });
  });
}
