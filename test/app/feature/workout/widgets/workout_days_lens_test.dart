import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(WorkoutDaysLens, () {
    late WorkoutLogBloc workoutLogBloc;
    late UserSettingsBloc userSettingsBloc;

    void stub(WorkoutLogState state) {
      when(() => workoutLogBloc.state).thenReturn(state);
      when(
        () => workoutLogBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
    }

    setUp(() {
      workoutLogBloc = MockWorkoutLogBloc();
      userSettingsBloc = MockUserSettingsBloc();
      when(() => userSettingsBloc.state).thenReturn(const UserSettingsState());
      when(
        () => userSettingsBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
    });

    WorkoutLogEntry entry(DateTime day, {double weight = 100, int reps = 5}) {
      return WorkoutLogEntry(
        id: 'e-${day.millisecondsSinceEpoch}-$weight',
        loggedAt: day,
        name: 'Bench Press',
        workoutGroupId: 'push',
        sets: [WorkoutSet(weight: weight, reps: reps)],
      );
    }

    WorkoutLogState twoMonthState() {
      return WorkoutLogState(
        workoutEntries: [
          entry(DateTime(2026, 5, 10, 8)),
          entry(DateTime(2026, 5, 15, 8), weight: 110),
          entry(DateTime(2026, 6, 10, 8), weight: 120),
          entry(DateTime(2026, 6, 14, 8), weight: 130),
        ],
      );
    }

    void useTallWindow(WidgetTester tester) {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    testWidgets('shows an empty state when no entries are logged', (
      tester,
    ) async {
      stub(const WorkoutLogState());
      await tester.pumpPumpPumpItUP(
        deps: [workoutLogBloc, userSettingsBloc],
        const WorkoutDaysLens(),
      );

      expect(find.byType(PageView), findsNothing);
    });

    testWidgets(
      'with entries, day cards render and rows are initially hidden',
      (
        tester,
      ) async {
        useTallWindow(tester);
        stub(twoMonthState());
        await tester.pumpPumpPumpItUP(
          deps: [workoutLogBloc, userSettingsBloc],
          const WorkoutDaysLens(),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ExpansionTile), findsWidgets);
        expect(find.byType(LoggedWorkoutRow), findsNothing);
      },
    );

    testWidgets('expanding a day card reveals its LoggedWorkoutRow', (
      tester,
    ) async {
      useTallWindow(tester);
      stub(twoMonthState());
      await tester.pumpPumpPumpItUP(
        deps: [workoutLogBloc, userSettingsBloc],
        const WorkoutDaysLens(),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ExpansionTile).first);
      await tester.pumpAndSettle();

      expect(find.byType(LoggedWorkoutRow), findsWidgets);
    });
  });
}
