import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(LoggedWorkoutRow, () {
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
      registerFallbackValue(const WorkoutLogEvent.workoutRemoved('x'));
      registerFallbackValue(
        const UserSettingsEvent.usualWorkoutAdded('push', 'x', []),
      );
    });

    void stubSettings(UserSettingsState state) {
      when(() => userSettingsBloc.state).thenReturn(state);
    }

    void useTallWindow(WidgetTester tester) {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    WorkoutLogEntry strengthEntry({
      String? usualWorkoutId,
      List<WorkoutSet> sets = const [WorkoutSet(weight: 135, reps: 8)],
    }) {
      return WorkoutLogEntry(
        id: 'entry',
        loggedAt: testNow,
        workoutGroupId: 'push',
        name: 'Bench Press',
        sets: sets,
        usualWorkoutId: usualWorkoutId,
      );
    }

    WorkoutLogEntry cardioEntry({
      String? usualWorkoutId,
      Duration duration = const Duration(minutes: 30),
    }) {
      return WorkoutLogEntry(
        id: 'entry',
        loggedAt: testNow,
        workoutGroupId: 'push',
        name: 'Running',
        type: WorkoutType.cardio,
        duration: duration,
        usualWorkoutId: usualWorkoutId,
      );
    }

    Future<void> pumpRow(
      WidgetTester tester,
      WorkoutLogEntry workoutLogEntry, {
      bool expandedByDefault = true,
    }) {
      useTallWindow(tester);
      return tester.pumpPumpPumpItUP(
        deps: [workoutLogBloc, userSettingsBloc],
        LoggedWorkoutRow(
          workoutLogEntry: workoutLogEntry,
          weightUnit: WeightUnit.lb,
          expandedByDefault: expandedByDefault,
        ),
      );
    }

    testWidgets('with no linked usual shows the "save as usual" footer', (
      tester,
    ) async {
      await pumpRow(tester, strengthEntry());
      await tester.pumpAndSettle();

      expect(find.byType(UpdateUsualButton), findsOneWidget);

      await tester.ensureVisible(find.byType(UpdateUsualButton));
      await tester.tap(
        find.descendant(
          of: find.byType(UpdateUsualButton),
          matching: find.byType(TextButton),
        ),
      );
      await tester.pump();

      verify(
        () => userSettingsBloc.add(
          any(that: isA<UserSettingsEvent>()),
        ),
      ).called(1);
    });

    testWidgets('matching usual by id with equal sets shows no footer', (
      tester,
    ) async {
      stubSettings(
        const UserSettingsState(
          usualWorkouts: {
            'push': [
              UsualWorkout(
                id: 'u',
                name: 'Bench Press',
                sets: [WorkoutSet(weight: 135, reps: 8)],
              ),
            ],
          },
        ),
      );
      await pumpRow(tester, strengthEntry(usualWorkoutId: 'u'));
      await tester.pumpAndSettle();

      expect(find.byType(UpdateUsualButton), findsNothing);
    });

    testWidgets(
      'strength linked usual that differs shows "update usual to match"',
      (tester) async {
        stubSettings(
          const UserSettingsState(
            usualWorkouts: {
              'push': [
                UsualWorkout(
                  id: 'u',
                  name: 'Bench Press',
                  sets: [WorkoutSet(weight: 100, reps: 8)],
                ),
              ],
            },
          ),
        );
        await pumpRow(tester, strengthEntry(usualWorkoutId: 'u'));
        await tester.pumpAndSettle();

        expect(find.byType(UpdateUsualButton), findsOneWidget);

        await tester.ensureVisible(find.byType(UpdateUsualButton));
        await tester.tap(
          find.descendant(
            of: find.byType(UpdateUsualButton),
            matching: find.byType(TextButton),
          ),
        );
        await tester.pump();

        verify(
          () => userSettingsBloc.add(
            const UserSettingsEvent.usualWorkoutSetsChanged(
              'push',
              'u',
              [WorkoutSet(weight: 135, reps: 8)],
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'cardio linked usual whose duration differs updates the usual',
      (tester) async {
        registerFallbackValue(
          const UserSettingsEvent.usualWorkoutDurationChanged(
            'push',
            'u',
            Duration.zero,
          ),
        );
        stubSettings(
          const UserSettingsState(
            usualWorkouts: {
              'push': [
                UsualWorkout(
                  id: 'u',
                  name: 'Running',
                  type: WorkoutType.cardio,
                  duration: Duration(minutes: 20),
                ),
              ],
            },
          ),
        );
        await pumpRow(tester, cardioEntry(usualWorkoutId: 'u'));
        await tester.pumpAndSettle();

        expect(find.byType(UpdateUsualButton), findsOneWidget);

        await tester.ensureVisible(find.byType(UpdateUsualButton));
        await tester.tap(
          find.descendant(
            of: find.byType(UpdateUsualButton),
            matching: find.byType(TextButton),
          ),
        );
        await tester.pump();

        verify(
          () => userSettingsBloc.add(
            const UserSettingsEvent.usualWorkoutDurationChanged(
              'push',
              'u',
              Duration(minutes: 30),
            ),
          ),
        ).called(1);
      },
    );

    testWidgets('linked usual matched by name only is detected', (
      tester,
    ) async {
      stubSettings(
        const UserSettingsState(
          usualWorkouts: {
            'push': [
              UsualWorkout(
                id: 'u',
                name: 'bench press',
                sets: [WorkoutSet(weight: 135, reps: 8)],
              ),
            ],
          },
        ),
      );
      await pumpRow(tester, strengthEntry());
      await tester.pumpAndSettle();

      // Matched by name with identical sets: no diff, so no footer button.
      expect(find.byType(UpdateUsualButton), findsNothing);
    });

    testWidgets('removing the entry adds workoutRemoved', (tester) async {
      await pumpRow(tester, strengthEntry());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_forever_outlined));
      await tester.pump();

      verify(
        () => workoutLogBloc.add(
          const WorkoutLogEvent.workoutRemoved('entry'),
        ),
      ).called(1);
    });

    testWidgets('editing a set adds workoutSetsChanged', (tester) async {
      registerFallbackValue(
        const WorkoutLogEvent.workoutSetsChanged('entry', []),
      );
      await pumpRow(tester, strengthEntry());
      await tester.pumpAndSettle();

      final weightField = find.byType(TextField).first;
      await tester.enterText(weightField, '140');
      await tester.pump();

      verify(
        () => workoutLogBloc.add(
          any(that: isA<WorkoutLogEvent>()),
        ),
      ).called(greaterThanOrEqualTo(1));
    });

    testWidgets('editing cardio time adds workoutDurationChanged', (
      tester,
    ) async {
      registerFallbackValue(
        const WorkoutLogEvent.workoutDurationChanged('entry', Duration.zero),
      );
      await pumpRow(tester, cardioEntry());
      await tester.pumpAndSettle();

      final timeField = find.byType(TextField).first;
      await tester.enterText(timeField, '45');
      await tester.pump();

      verify(
        () => workoutLogBloc.add(
          any(that: isA<WorkoutLogEvent>()),
        ),
      ).called(greaterThanOrEqualTo(1));
    });
  });
}
