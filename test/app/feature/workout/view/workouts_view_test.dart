import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

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

    testWidgets('renders the VolumeBar', (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpPumpPumpItUP(
        deps: [workoutLogBloc, userSettingsBloc],
        const WorkoutsView(),
      );

      expect(find.byType(VolumeBar), findsOneWidget);
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

      await tester.enterText(
        find.byKey(const Key('group-name-push')),
        'Press Day',
      );
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
        await tester.tap(find.byIcon(Icons.delete_outline).first);
        await tester.pump();

        verify(
          () => userSettingsBloc.add(
            const UserSettingsEvent.workoutGroupRemoved('push'),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'tapping delete on a non-empty group shows a snackbar and does not dispatch workoutGroupRemoved',
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

        await tester.tap(find.byIcon(Icons.delete_outline).first);
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
      'Add group button opens dialog and submitting a name dispatches workoutGroupAdded',
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
  });
}
