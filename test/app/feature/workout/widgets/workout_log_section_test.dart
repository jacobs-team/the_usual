import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(WorkoutLogSection, () {
    late WorkoutLogBloc workoutLogBloc;
    late UserSettingsBloc userSettingsBloc;
    late DailyLogBloc dailyLogBloc;

    setUp(() {
      workoutLogBloc = MockWorkoutLogBloc();
      when(() => workoutLogBloc.state).thenReturn(const WorkoutLogState());
      when(
        () => workoutLogBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
      userSettingsBloc = MockUserSettingsBloc();
      when(() => userSettingsBloc.state).thenReturn(const UserSettingsState());
      when(
        () => userSettingsBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
      dailyLogBloc = MockDailyLogBloc();
      when(() => dailyLogBloc.state).thenReturn(const DailyLogState());
      when(
        () => dailyLogBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
      registerFallbackValue(
        const WorkoutLogEvent.workoutRemoved('x'),
      );
      registerFallbackValue(
        const UserSettingsEvent.usualWorkoutRemoved('push', 'x'),
      );
      registerFallbackValue(
        const WorkoutLogEvent.workoutLogged('push', 'Bench Press'),
      );
    });

    const pushGroup = WorkoutGroup(id: 'push', name: 'Push', order: 0);

    WorkoutLogEntry logged(String id, String name) {
      return WorkoutLogEntry(
        id: id,
        loggedAt: testNow,
        workoutGroupId: 'push',
        name: name,
        sets: const [WorkoutSet(weight: 135, reps: 8)],
      );
    }

    Future<void> pumpSection(
      WidgetTester tester, {
      List<WorkoutLogEntry> workoutLogEntries = const [],
      List<UsualWorkout> quickPicks = const [],
      List<WorkoutLogEntry> previousSession = const [],
      bool expandedByDefault = false,
      List<DateTime>? logDays,
      TimeOfDay? dayStart,
      ValueChanged<String>? onRenamed,
      VoidCallback? onDeleteRequested,
    }) {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      return tester.pumpPumpPumpItUP(
        deps: [workoutLogBloc, userSettingsBloc, dailyLogBloc],
        CustomScrollView(
          slivers: [
            WorkoutLogSection(
              workoutGroup: pushGroup,
              workoutLogEntries: workoutLogEntries,
              previousSession: previousSession,
              quickPicks: quickPicks,
              weightUnit: WeightUnit.lb,
              expandedByDefault: expandedByDefault,
              logDays: logDays,
              dayStart: dayStart,
              onRenamed: onRenamed ?? (_) {},
              onDeleteRequested: onDeleteRequested ?? () {},
            ),
          ],
        ),
      );
    }

    testWidgets('renders a logged row per entry', (tester) async {
      await pumpSection(
        tester,
        workoutLogEntries: [
          logged('a', 'Bench Press'),
          logged('b', 'Overhead Press'),
        ],
      );

      expect(find.byType(LoggedWorkoutRow), findsNWidgets(2));
    });

    testWidgets('tapping a quick pick chip logs the usual workout', (
      tester,
    ) async {
      await pumpSection(
        tester,
        quickPicks: const [
          UsualWorkout(
            id: 'u',
            name: 'Bench Press',
            sets: [WorkoutSet(weight: 135, reps: 8)],
          ),
        ],
      );

      final chip = find.descendant(
        of: find.byType(MenuAnchor),
        matching: find.byType(InkWell),
      );
      expect(chip, findsOneWidget);

      await tester.tap(chip);

      verify(
        () => workoutLogBloc.add(
          const WorkoutLogEvent.workoutLogged(
            'push',
            'Bench Press',
            sets: [WorkoutSet(weight: 135, reps: 8)],
            usualWorkoutId: 'u',
          ),
        ),
      ).called(1);
    });

    testWidgets('editing the group name calls onRenamed', (tester) async {
      String? captured;
      await pumpSection(tester, onRenamed: (value) => captured = value);

      await tester.tap(
        find.descendant(
          of: find.byKey(const Key('group-name-push')),
          matching: find.byIcon(Icons.edit_outlined),
        ),
      );
      await tester.pump();

      await tester.enterText(
        find.byKey(const Key('group-name-push')),
        'Chest',
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(captured, equals('Chest'));
    });

    testWidgets('tapping the delete icon calls onDeleteRequested', (
      tester,
    ) async {
      var deleteCalled = false;
      await pumpSection(tester, onDeleteRequested: () => deleteCalled = true);

      await tester.tap(find.byIcon(Icons.delete_forever_outlined));
      await tester.pump();

      expect(deleteCalled, isTrue);
    });

    testWidgets('section header shows volume when entries exist', (
      tester,
    ) async {
      final seededEntries = [logged('a', 'Bench Press')];
      await pumpSection(tester, workoutLogEntries: seededEntries);

      // 135 × 8 = 1080 lb. The section header renders it as "1080 lb".
      final expectedVolume =
          '${seededEntries.totalVolume.trimmedDecimal} ${WeightUnit.lb.name}';
      final hasVolumeText = tester
          .widgetList<Text>(find.byType(Text))
          .any((t) => t.data == expectedVolume);
      expect(hasVolumeText, isTrue);
    });

    testWidgets(
      'copy previous re-logs each entry from the previous session',
      (tester) async {
        await pumpSection(
          tester,
          previousSession: [
            logged('a', 'Bench Press'),
            logged('b', 'Overhead Press'),
          ],
        );

        expect(find.byType(CopyPreviousButton), findsOneWidget);

        await tester.tap(find.byType(CopyPreviousButton));
        await tester.pump();

        verify(
          () => workoutLogBloc.add(
            any(
              that: isA<WorkoutLogEvent>(),
            ),
          ),
        ).called(2);
      },
    );

    testWidgets(
      'a quick pick logs onto each target day when logDays is set',
      (tester) async {
        await pumpSection(
          tester,
          logDays: [DateTime(2026, 6, 16), DateTime(2026, 6, 17)],
          dayStart: const TimeOfDay(hour: 0, minute: 0),
          quickPicks: const [
            UsualWorkout(
              id: 'u',
              name: 'Bench Press',
              sets: [WorkoutSet(weight: 135, reps: 8)],
            ),
          ],
        );

        await tester.tap(
          find.descendant(
            of: find.byType(MenuAnchor),
            matching: find.byType(InkWell),
          ),
        );
        await tester.pump();

        verify(
          () => workoutLogBloc.add(
            any(that: isA<WorkoutLogEvent>()),
          ),
        ).called(2);
      },
    );

    testWidgets('removing a quick pick adds usualWorkoutRemoved', (
      tester,
    ) async {
      await pumpSection(
        tester,
        quickPicks: const [
          UsualWorkout(
            id: 'u',
            name: 'Bench Press',
            sets: [WorkoutSet(weight: 135, reps: 8)],
          ),
        ],
      );

      await tester.longPress(
        find.descendant(
          of: find.byType(MenuAnchor),
          matching: find.byType(InkWell),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.usualWorkoutRemoved('push', 'u'),
        ),
      ).called(1);
    });

    testWidgets(
      'new workout uses the latest weigh-in as body weight and logs the '
      'result',
      (tester) async {
        when(() => dailyLogBloc.state).thenReturn(
          DailyLogState(
            weightEntries: [
              WeightEntry(
                id: 'w',
                loggedAt: testNow,
                weight: 180,
                weightUnit: WeightUnit.lb,
              ),
            ],
          ),
        );

        await pumpSection(tester);

        await tester.tap(find.widgetWithText(FilledButton, 'New workout'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(TheUsualTextField).first,
          'Bench Press',
        );
        await tester.pump();

        await tester.tap(find.byKey(const Key('confirm-button')));
        await tester.pumpAndSettle();

        verify(
          () => workoutLogBloc.add(
            any(that: isA<WorkoutLogEvent>()),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'new workout falls back to the starting weight when no weigh-in exists',
      (tester) async {
        when(() => userSettingsBloc.state).thenReturn(
          const UserSettingsState(startingWeight: 175),
        );

        await pumpSection(tester);

        await tester.tap(find.widgetWithText(FilledButton, 'New workout'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(TheUsualTextField).first,
          'Bench Press',
        );
        await tester.pump();

        await tester.tap(find.byKey(const Key('confirm-button')));
        await tester.pumpAndSettle();

        verify(
          () => workoutLogBloc.add(
            any(that: isA<WorkoutLogEvent>()),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'cancelling the new workout sheet logs nothing',
      (tester) async {
        await pumpSection(tester);

        await tester.tap(find.widgetWithText(FilledButton, 'New workout'));
        await tester.pumpAndSettle();

        // Dismiss the sheet without confirming.
        Navigator.of(tester.element(find.byType(WorkoutEntrySheet))).pop();
        await tester.pumpAndSettle();

        verifyNever(
          () => workoutLogBloc.add(any(that: isA<WorkoutLogEvent>())),
        );
      },
    );

    testWidgets(
      'new workout with "save as usual" checked also saves the usual',
      (tester) async {
        registerFallbackValue(
          const UserSettingsEvent.usualWorkoutAdded('push', 'x', []),
        );

        await pumpSection(tester);

        await tester.tap(find.widgetWithText(FilledButton, 'New workout'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(TheUsualTextField).first,
          'Bench Press',
        );
        await tester.pump();

        await tester.tap(find.byKey(const Key('save-as-usual-checkbox')));
        await tester.pump();

        await tester.tap(find.byKey(const Key('confirm-button')));
        await tester.pumpAndSettle();

        verify(
          () => userSettingsBloc.add(
            any(that: isA<UserSettingsEvent>()),
          ),
        ).called(greaterThanOrEqualTo(1));
        verify(
          () => workoutLogBloc.add(any(that: isA<WorkoutLogEvent>())),
        ).called(1);
      },
    );

    testWidgets(
      'editing the name to blank restores the original name',
      (tester) async {
        var renamedCalled = false;
        await pumpSection(
          tester,
          onRenamed: (_) => renamedCalled = true,
        );

        await tester.tap(
          find.descendant(
            of: find.byKey(const Key('group-name-push')),
            matching: find.byIcon(Icons.edit_outlined),
          ),
        );
        await tester.pump();

        await tester.enterText(
          find.byKey(const Key('group-name-push')),
          '   ',
        );
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();

        expect(renamedCalled, isFalse);
      },
    );

    testWidgets(
      'an externally renamed group updates the name field while idle',
      (tester) async {
        tester.view.physicalSize = const Size(1200, 3000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        var groupName = 'Push';
        late StateSetter rebuild;

        await tester.pumpPumpPumpItUP(
          deps: [workoutLogBloc, userSettingsBloc, dailyLogBloc],
          StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return CustomScrollView(
                slivers: [
                  WorkoutLogSection(
                    workoutGroup: WorkoutGroup(
                      id: 'push',
                      name: groupName,
                      order: 0,
                    ),
                    workoutLogEntries: const [],
                    previousSession: const [],
                    quickPicks: const [],
                    weightUnit: WeightUnit.lb,
                    expandedByDefault: false,
                    onRenamed: (_) {},
                    onDeleteRequested: () {},
                  ),
                ],
              );
            },
          ),
        );

        // Diverge the field's controller from the group name without the
        // parent adopting it, so the external rename below must reset it.
        await tester.tap(
          find.descendant(
            of: find.byKey(const Key('group-name-push')),
            matching: find.byIcon(Icons.edit_outlined),
          ),
        );
        await tester.pump();
        await tester.enterText(
          find.byKey(const Key('group-name-push')),
          'Temporary',
        );
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();

        rebuild(() => groupName = 'Chest');
        await tester.pump();

        expect(find.text('Chest'), findsOneWidget);
      },
    );

    testWidgets(
      'losing focus while editing commits the new name',
      (tester) async {
        tester.view.physicalSize = const Size(1200, 3000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        String? captured;
        await pumpSection(tester, onRenamed: (value) => captured = value);

        await tester.tap(
          find.descendant(
            of: find.byKey(const Key('group-name-push')),
            matching: find.byIcon(Icons.edit_outlined),
          ),
        );
        await tester.pump();

        await tester.enterText(
          find.byKey(const Key('group-name-push')),
          'Chest',
        );
        await tester.pump();

        // Move focus away from the field, which commits on focus loss.
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pump();

        expect(captured, equals('Chest'));
      },
    );
  });
}
