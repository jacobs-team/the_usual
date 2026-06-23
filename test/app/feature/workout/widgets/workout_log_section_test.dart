import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(WorkoutLogSection, () {
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
      bool expandedByDefault = false,
      List<DateTime>? logDays,
      TimeOfDay? dayStart,
    }) {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      return tester.pumpPumpPumpItUP(
        deps: [workoutLogBloc, userSettingsBloc],
        CustomScrollView(
          slivers: [
            WorkoutLogSection(
              workoutGroup: pushGroup,
              workoutLogEntries: workoutLogEntries,
              quickPicks: quickPicks,
              weightUnit: WeightUnit.lb,
              expandedByDefault: expandedByDefault,
              logDays: logDays,
              dayStart: dayStart,
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
  });
}
