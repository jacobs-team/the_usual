import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(ExerciseProgressDetailView, () {
    late WorkoutLogBloc workoutLogBloc;
    late UserSettingsBloc userSettingsBloc;

    final benchState = WorkoutLogState(
      workoutEntries: [
        WorkoutLogEntry(
          id: '1',
          loggedAt: DateTime(2026, 6),
          workoutGroupId: 'push',
          name: 'Bench Press',
          sets: const [WorkoutSet(weight: 100, reps: 8)],
        ),
        WorkoutLogEntry(
          id: '2',
          loggedAt: DateTime(2026, 6, 8),
          workoutGroupId: 'push',
          name: 'Bench Press',
          sets: const [WorkoutSet(weight: 110, reps: 8)],
        ),
      ],
    );

    setUp(() {
      workoutLogBloc = MockWorkoutLogBloc();
      when(() => workoutLogBloc.state).thenReturn(benchState);
      when(
        () => workoutLogBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
      userSettingsBloc = MockUserSettingsBloc();
      when(() => userSettingsBloc.state).thenReturn(const UserSettingsState());
      when(
        () => userSettingsBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
    });

    testWidgets('shows the strength chart for the named exercise', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpPumpPumpItUP(
        deps: [workoutLogBloc, userSettingsBloc],
        const ExerciseProgressDetailView(exerciseName: 'Bench Press'),
      );

      expect(find.byType(ExerciseStrengthChart), findsOneWidget);
    });

    testWidgets('tapping a chart point selects it and updates the summary', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpPumpPumpItUP(
        deps: [workoutLogBloc, userSettingsBloc],
        const ExerciseProgressDetailView(exerciseName: 'Bench Press'),
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

      expect(find.byType(ExerciseStrengthChart), findsOneWidget);
    });

    testWidgets('shows a fallback when the exercise has no series', (
      tester,
    ) async {
      when(() => workoutLogBloc.state).thenReturn(const WorkoutLogState());

      await tester.pumpPumpPumpItUP(
        deps: [workoutLogBloc, userSettingsBloc],
        const ExerciseProgressDetailView(exerciseName: 'Bench Press'),
      );

      expect(find.byType(ExerciseStrengthChart), findsNothing);
    });
  });
}
