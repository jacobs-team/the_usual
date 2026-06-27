import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(ExercisesLens, () {
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

    testWidgets('lists a row with a sparkline per qualifying exercise', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        deps: [workoutLogBloc, userSettingsBloc],
        const ExercisesLens(),
      );

      expect(find.byType(ExerciseSparkline), findsOneWidget);
    });

    testWidgets('shows an empty state with no qualifying exercises', (
      tester,
    ) async {
      when(() => workoutLogBloc.state).thenReturn(const WorkoutLogState());

      await tester.pumpPumpPumpItUP(
        deps: [workoutLogBloc, userSettingsBloc],
        const ExercisesLens(),
      );

      expect(find.byType(ExerciseSparkline), findsNothing);
    });

    testWidgets('tapping a row opens the exercise detail', (tester) async {
      await tester.pumpPumpPumpItUP(
        deps: [workoutLogBloc, userSettingsBloc],
        const ExercisesLens(),
      );

      await tester.tap(find.byType(ExerciseSparkline).first);
      await tester.pumpAndSettle();

      expect(find.byType(ExerciseProgressDetailView), findsOneWidget);
    });
  });
}
