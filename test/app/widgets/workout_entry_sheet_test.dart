import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(WorkoutEntrySheet, () {
    setUpAll(() {
      registerFallbackValue(<MealPhoto>[]);
      registerFallbackValue(WeightUnit.lb);
    });

    /// Opens the sheet from a button and records whatever it pops with.
    Future<List<WorkoutEntryResult?>> showSheet(
      WidgetTester tester, {
      bool showAddToUsuals = false,
      MockWorkoutAiRepository? aiRepository,
      double? bodyWeight,
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
                  bodyWeight: bodyWeight,
                ),
              );
              results.add(result);
            },
            child: const Text('open'),
          ),
        ),
        deps: [?aiRepository],
      );

      await tester.tap(find.byKey(const Key('open-sheet-button')));
      await tester.pumpAndSettle();
      return results;
    }

    /// A configured AI repository so the sheet shows its AI controls.
    MockWorkoutAiRepository configuredAiRepository() {
      final repository = MockWorkoutAiRepository();
      when(() => repository.isConfigured).thenReturn(true);
      return repository;
    }

    testWidgets('confirm is disabled until a name is entered', (tester) async {
      await showSheet(tester);

      final confirmBefore = tester.widget<FilledButton>(
        find.byKey(const Key('confirm-button')),
      );
      expect(confirmBefore.onPressed, isNull);

      await tester.enterText(find.byType(TextFormField).first, 'Bench Press');
      await tester.pump();

      final confirmAfter = tester.widget<FilledButton>(
        find.byKey(const Key('confirm-button')),
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
      await tester.tap(find.byKey(const Key('confirm-button')));
      await tester.pumpAndSettle();

      expect(popped, isNotNull);
      expect(popped!.name, equals('Squat'));
      expect(popped!.sets, isA<List<WorkoutSet>>());
    });

    testWidgets(
        'the save-as-usual checkbox is absent when showAddToUsuals is false',
        (tester) async {
      await showSheet(tester, showAddToUsuals: false);
      // The bodyweight checkbox is always present; the save-as-usual one is not.
      expect(
        find.byKey(const Key('bodyweight-checkbox')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('save-as-usual-checkbox')), findsNothing);
    });

    testWidgets('the save-as-usual checkbox is shown when showAddToUsuals true',
        (tester) async {
      await showSheet(tester, showAddToUsuals: true);
      expect(
        find.byKey(const Key('save-as-usual-checkbox')),
        findsOneWidget,
      );
    });

    testWidgets('addToUsuals is false by default in the popped result',
        (tester) async {
      final results = await showSheet(tester, showAddToUsuals: true);

      await tester.enterText(find.byType(TextFormField).first, 'Deadlift');
      await tester.pump();
      await tester.tap(find.byKey(const Key('confirm-button')));
      await tester.pumpAndSettle();

      expect(results.single, isNotNull);
      expect(results.single!.addToUsuals, isFalse);
    });

    testWidgets('toggling the save-as-usual checkbox flips addToUsuals',
        (tester) async {
      final results = await showSheet(tester, showAddToUsuals: true);

      await tester.enterText(find.byType(TextFormField).first, 'Deadlift');
      await tester.pump();
      await tester.tap(find.byKey(const Key('save-as-usual-checkbox')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('confirm-button')));
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

    // ── AI: camera button gating ─────────────────────────────────────────────

    testWidgets('camera button is absent when AI is not configured',
        (tester) async {
      // pumpPumpPumpItUP registers a WorkoutAiRepository with isConfigured=false
      // by default — no override needed.
      await showSheet(tester);

      expect(find.byIcon(Icons.photo_camera_outlined), findsNothing);
    });

    testWidgets('camera button is present when AI is configured',
        (tester) async {
      await showSheet(tester, aiRepository: configuredAiRepository());

      expect(find.byIcon(Icons.photo_camera_outlined), findsOneWidget);
    });

    // ── AI: suggestion chips fill the name field ─────────────────────────────

    testWidgets(
        'given suggestions exist, chips render and tapping one fills the name',
        (tester) async {
      final repository = configuredAiRepository();
      when(
        () => repository.suggestNamesFromPhoto(any()),
      ).thenAnswer((_) async => ['Lat Pulldown', 'Cable Row']);

      await showSheet(tester, aiRepository: repository);

      // Seed suggestions via the @visibleForTesting entry point.
      final sheetState = tester.state<WorkoutEntrySheetState>(
        find.byType(WorkoutEntrySheet),
      );
      sheetState.applySuggestionsForTest(['Lat Pulldown', 'Cable Row']);
      await tester.pump();

      expect(find.byType(ActionChip), findsNWidgets(2));

      await tester.tap(find.widgetWithText(ActionChip, 'Lat Pulldown'));
      await tester.pump();

      final nameField = tester.widget<TextFormField>(
        find.byType(TextFormField).first,
      );
      expect(nameField.controller?.text, equals('Lat Pulldown'));
      expect(find.byType(ActionChip), findsNothing);
    });

    // ── Bodyweight checkbox disabled message ─────────────────────────────────

    testWidgets(
        'tapping bodyweight checkbox when bodyWeight is null shows inline hint',
        (tester) async {
      await showSheet(tester);

      await tester.tap(find.byKey(const Key('bodyweight-checkbox')));
      await tester.pump();

      expect(find.byKey(const Key('bodyweight-hint')), findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);

      // The checkbox must remain unchecked.
      final checkbox = tester.widget<Checkbox>(
        find.byKey(const Key('bodyweight-checkbox')),
      );
      expect(checkbox.value, isFalse);
    });

    // ── Bodyweight estimation on confirm ─────────────────────────────────────

    testWidgets(
        'with bodyWeight:200 and estimateBodyweightLoad=>140, '
        'confirming sets weight on auto sets', (tester) async {
      final repository = configuredAiRepository();

      // Register the stub after pumpPumpPumpItUP (inside showSheet) has run
      // so the named `any()` matchers don't leak into initHydratedStorage.
      final results = await showSheet(
        tester,
        aiRepository: repository,
        bodyWeight: 200,
      );

      when(
        () => repository.estimateBodyweightLoad(
          exerciseName: any(named: 'exerciseName'),
          bodyWeight: any(named: 'bodyWeight'),
          unit: any(named: 'unit'),
        ),
      ).thenAnswer((_) async => 140.0);

      await tester.enterText(find.byType(TextFormField).first, 'Pull-up');
      await tester.pump();

      // Tick the bodyweight checkbox.
      await tester.tap(find.byKey(const Key('bodyweight-checkbox')));
      await tester.pump();

      // Enter reps in the set field (weight left blank for auto-estimate).
      await tester.enterText(find.byKey(const Key('set-reps-0')), '8');
      await tester.pump();

      await tester.tap(find.byKey(const Key('confirm-button')));
      await tester.pumpAndSettle();

      expect(results.single, isNotNull);
      final sets = results.single!.sets;
      expect(sets, isNotEmpty);
      expect(
        sets.first,
        isA<WorkoutSet>()
            .having((s) => s.weight, 'weight', equals(140.0))
            .having(
              (s) => s.weightAutoEstimated,
              'weightAutoEstimated',
              isTrue,
            ),
      );
    });
  });
}
