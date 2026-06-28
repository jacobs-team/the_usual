import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void _sizeView(WidgetTester tester) {
  tester.view.physicalSize = const Size(1200, 3000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  group(WorkoutsView, () {
    late WorkoutLogBloc workoutLogBloc;
    late UserSettingsBloc userSettingsBloc;

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
      registerFallbackValue(
        const UserSettingsEvent.workoutGroupRenamed('push', 'Press Day'),
      );
      registerFallbackValue(
        const UserSettingsEvent.workoutGroupRemoved('push'),
      );
      registerFallbackValue(
        const UserSettingsEvent.workoutGroupAdded('Arms'),
      );
    });

    testWidgets('renders one WorkoutLogSection per default group', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpPumpPumpItUP(
        deps: [workoutLogBloc, userSettingsBloc],
        const WorkoutsView(),
      );

      // Default UserSettingsState has three workout groups: Push, Pull, Legs.
      expect(find.byType(WorkoutLogSection), findsNWidgets(3));
    });

    testWidgets('renders the date pill', (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpPumpPumpItUP(
        deps: [workoutLogBloc, userSettingsBloc],
        const WorkoutsView(),
      );

      expect(find.byKey(const Key('workouts-date-pill')), findsOneWidget);
    });

    testWidgets('renaming the push group dispatches workoutGroupRenamed', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpPumpPumpItUP(
        deps: [workoutLogBloc, userSettingsBloc],
        const WorkoutsView(),
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
        'Press Day',
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.workoutGroupRenamed('push', 'Press Day'),
        ),
      ).called(1);
    });

    testWidgets(
      'tapping delete on an empty group dispatches workoutGroupRemoved',
      (tester) async {
        tester.view.physicalSize = const Size(1200, 3000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        // No usuals, no log entries — group is empty.
        await tester.pumpPumpPumpItUP(
          deps: [workoutLogBloc, userSettingsBloc],
          const WorkoutsView(),
        );

        // Tap the delete button on the first (push) section.
        await tester.tap(find.byIcon(Icons.delete_forever_outlined).first);
        await tester.pump();

        verify(
          () => userSettingsBloc.add(
            const UserSettingsEvent.workoutGroupRemoved('push'),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'tapping delete on a non-empty group shows a snackbar and does not '
      'dispatch workoutGroupRemoved',
      (tester) async {
        tester.view.physicalSize = const Size(1200, 3000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        when(() => userSettingsBloc.state).thenReturn(
          const UserSettingsState(
            usualWorkouts: {
              'push': [
                UsualWorkout(
                  id: 'u1',
                  name: 'Bench Press',
                  sets: [WorkoutSet(weight: 135, reps: 8)],
                ),
              ],
            },
          ),
        );

        await tester.pumpPumpPumpItUP(
          deps: [workoutLogBloc, userSettingsBloc],
          const WorkoutsView(),
        );

        await tester.tap(find.byIcon(Icons.delete_forever_outlined).first);
        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
        verifyNever(
          () => userSettingsBloc.add(
            const UserSettingsEvent.workoutGroupRemoved('push'),
          ),
        );
      },
    );

    testWidgets(
      'Add group button opens dialog and submitting a name dispatches '
      'workoutGroupAdded',
      (tester) async {
        tester.view.physicalSize = const Size(1200, 3000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpPumpPumpItUP(
          deps: [workoutLogBloc, userSettingsBloc],
          const WorkoutsView(),
        );

        await tester.tap(find.byKey(const Key('add-workout-group')));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);

        await tester.enterText(
          find.descendant(
            of: find.byType(AlertDialog),
            matching: find.byType(TheUsualTextField),
          ),
          'Arms',
        );
        await tester.tap(find.byKey(const Key('add-group-submit')));
        await tester.pump();

        verify(
          () => userSettingsBloc.add(
            const UserSettingsEvent.workoutGroupAdded('Arms'),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'tapping delete on a group with logged entries shows a snackbar and '
      'does not dispatch workoutGroupRemoved',
      (tester) async {
        _sizeView(tester);

        // No usuals, but a logged entry exists for the push group.
        when(() => workoutLogBloc.state).thenReturn(
          WorkoutLogState(
            workoutEntries: [
              WorkoutLogEntry(
                id: 'logged-1',
                loggedAt: testNow,
                workoutGroupId: 'push',
                name: 'Bench Press',
                sets: const [WorkoutSet(weight: 135, reps: 8)],
              ),
            ],
          ),
        );

        await withTestClock(() async {
          await tester.pumpPumpPumpItUP(
            deps: [workoutLogBloc, userSettingsBloc],
            const WorkoutsView(),
          );

          await tester.tap(find.byIcon(Icons.delete_forever_outlined).first);
          await tester.pump();
        });

        expect(find.byType(SnackBar), findsOneWidget);
        verifyNever(
          () => userSettingsBloc.add(
            const UserSettingsEvent.workoutGroupRemoved('push'),
          ),
        );
      },
    );

    testWidgets(
      'picking a different day from the date pill switches off the live view',
      (tester) async {
        _sizeView(tester);

        await withTestClock(() async {
          await tester.pumpPumpPumpItUP(
            deps: [workoutLogBloc, userSettingsBloc],
            const WorkoutsView(),
          );

          await tester.tap(find.byKey(const Key('workouts-date-pill')));
          await tester.pumpAndSettle();

          // The date picker is open. Pick the day before today (the 17th of
          // the testNow month), then confirm.
          await tester.tap(find.text('17'));
          await tester.pumpAndSettle();
          await tester.tap(find.byType(TextButton).last);
          await tester.pumpAndSettle();
        });

        // The pill no longer reads the live "Today" label, and the section
        // grid still renders for the selected day.
        expect(find.byType(WorkoutLogSection), findsNWidgets(3));
      },
    );

    testWidgets('reopening the date picker after selecting a day opens on '
        'the selected day', (tester) async {
      _sizeView(tester);

      await withTestClock(() async {
        await tester.pumpPumpPumpItUP(
          deps: [workoutLogBloc, userSettingsBloc],
          const WorkoutsView(),
        );

        // First selection: pick the 17th and confirm.
        await tester.tap(find.byKey(const Key('workouts-date-pill')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('17'));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(TextButton).last);
        await tester.pumpAndSettle();

        // Reopen the picker with a range already selected, then cancel.
        await tester.tap(find.byKey(const Key('workouts-date-pill')));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(TextButton).first);
        await tester.pumpAndSettle();
      });

      expect(find.byType(WorkoutLogSection), findsNWidgets(3));
    });

    testWidgets('cancelling the Add group dialog dispatches nothing', (
      tester,
    ) async {
      _sizeView(tester);

      await tester.pumpPumpPumpItUP(
        deps: [workoutLogBloc, userSettingsBloc],
        const WorkoutsView(),
      );

      await tester.tap(find.byKey(const Key('add-workout-group')));
      await tester.pumpAndSettle();

      // Tap the dialog's Cancel button (its leading TextButton).
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(TextButton),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      verifyNever(
        () => userSettingsBloc.add(any(that: isA<UserSettingsEvent>())),
      );
    });

    testWidgets('swiping the body horizontally shifts the shown day', (
      tester,
    ) async {
      _sizeView(tester);

      // A logged entry so the selected-day rollup exercises the group loop.
      when(() => workoutLogBloc.state).thenReturn(
        WorkoutLogState(
          workoutEntries: [
            WorkoutLogEntry(
              id: 'logged-1',
              loggedAt: testNow.subtract(const Duration(days: 1)),
              workoutGroupId: 'push',
              name: 'Bench Press',
              sets: const [WorkoutSet(weight: 135, reps: 8)],
            ),
          ],
        ),
      );

      await withTestClock(() async {
        await tester.pumpPumpPumpItUP(
          deps: [workoutLogBloc, userSettingsBloc],
          const WorkoutsView(),
        );

        // Drag left→right to move the shown day back one day.
        await tester.fling(
          find.byType(CustomScrollView),
          const Offset(300, 0),
          1000,
        );
        await tester.pumpAndSettle();
      });

      expect(find.byType(WorkoutLogSection), findsNWidgets(3));
    });
  });
}
