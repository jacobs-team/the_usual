import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  const dayStart = TimeOfDay(hour: 0, minute: 0);

  group(WorkoutLogBloc, () {
    setUp(initHydratedStorage);

    WorkoutLogEntry workoutLogEntry({
      required String id,
      required DateTime loggedAt,
      String workoutGroupId = 'push',
      List<WorkoutSet> sets = const [WorkoutSet(weight: 100, reps: 10)],
    }) {
      return WorkoutLogEntry(
        id: id,
        loggedAt: loggedAt,
        workoutGroupId: workoutGroupId,
        name: id,
        sets: sets,
      );
    }

    test('initial state is the default WorkoutLogState', () {
      expect(WorkoutLogBloc().state, equals(const WorkoutLogState()));
    });

    blocTest<WorkoutLogBloc, WorkoutLogState>(
      'sampleDataSeeded fills the log with seeded strength sessions',
      build: WorkoutLogBloc.new,
      act: (bloc) => bloc.add(const WorkoutLogEvent.sampleDataSeeded()),
      expect: () => [
        isA<WorkoutLogState>().having(
          (s) => s.workoutEntries,
          'workoutEntries',
          isNotEmpty,
        ),
      ],
      verify: (bloc) {
        // The seeded sessions span multiple exercises across months, so the
        // strength rollup yields several trending series.
        final progress = bloc.state.strengthProgress(
          const TimeOfDay(hour: 0, minute: 0),
        );
        expect(progress.length, greaterThan(1));
        expect(progress.first.points.length, greaterThan(1));
      },
    );

    test('sampleUsualWorkouts seeds usuals under the default groups', () {
      final sampleUsualWorkouts = WorkoutLogBloc.sampleUsualWorkouts;
      expect(sampleUsualWorkouts.keys, containsAll(['push', 'pull', 'legs']));
      expect(sampleUsualWorkouts['push'], isNotEmpty);
    });

    group('workoutLogged', () {
      blocTest<WorkoutLogBloc, WorkoutLogState>(
        'appends a workout entry and records it as just logged',
        build: WorkoutLogBloc.new,
        act: (bloc) => bloc.add(
          const WorkoutLogEvent.workoutLogged(
            'push',
            'Bench Press',
            sets: [WorkoutSet(weight: 135, reps: 8)],
            usualWorkoutId: 'usual-1',
          ),
        ),
        expect: () => [
          isA<WorkoutLogState>()
              .having((s) => s.workoutEntries, 'workoutEntries', hasLength(1))
              .having(
                (s) => s.workoutEntries.single.usualWorkoutId,
                'usualWorkoutId',
                'usual-1',
              )
              .having(
                (s) => s.justLoggedWorkoutId,
                'justLoggedWorkoutId',
                isNotNull,
              ),
        ],
      );

      blocTest<WorkoutLogBloc, WorkoutLogState>(
        'ignores a blank name',
        build: WorkoutLogBloc.new,
        act: (bloc) =>
            bloc.add(const WorkoutLogEvent.workoutLogged('push', '  ')),
        expect: () => <WorkoutLogState>[],
      );

      blocTest<WorkoutLogBloc, WorkoutLogState>(
        'stamps loggedAt at the logical day start when a day is given',
        build: WorkoutLogBloc.new,
        act: (bloc) => bloc.add(
          WorkoutLogEvent.workoutLogged(
            'legs',
            'Squat',
            day: DateTime(2026, 6, 16),
            dayStart: const TimeOfDay(hour: 4, minute: 0),
          ),
        ),
        verify: (bloc) {
          final workoutLogEntry = bloc.state.workoutEntries.single;
          expect(
            workoutLogEntry.loggedAt,
            equals(
              DateTime(2026, 6, 16).atDayStart(
                const TimeOfDay(hour: 4, minute: 0),
              ),
            ),
          );
        },
      );
    });

    blocTest<WorkoutLogBloc, WorkoutLogState>(
      'workoutRemoved drops the matching entry',
      build: WorkoutLogBloc.new,
      seed: () => WorkoutLogState(
        workoutEntries: [
          workoutLogEntry(id: 'a', loggedAt: DateTime(2026, 6, 14)),
          workoutLogEntry(id: 'b', loggedAt: DateTime(2026, 6, 14)),
        ],
      ),
      act: (bloc) => bloc.add(const WorkoutLogEvent.workoutRemoved('a')),
      expect: () => [
        isA<WorkoutLogState>().having(
          (s) => s.workoutEntries.single.id,
          'remaining entry id',
          'b',
        ),
      ],
    );

    blocTest<WorkoutLogBloc, WorkoutLogState>(
      'workoutSetsChanged replaces the sets of the matching entry only',
      build: WorkoutLogBloc.new,
      seed: () => WorkoutLogState(
        workoutEntries: [
          workoutLogEntry(id: 'a', loggedAt: DateTime(2026, 6, 14)),
          workoutLogEntry(id: 'b', loggedAt: DateTime(2026, 6, 14)),
        ],
      ),
      act: (bloc) => bloc.add(
        const WorkoutLogEvent.workoutSetsChanged('a', [
          WorkoutSet(weight: 200, reps: 5),
        ]),
      ),
      expect: () => [
        isA<WorkoutLogState>()
            .having(
              (s) => s.workoutEntries.first.sets.single.weight,
              'updated weight',
              200,
            )
            .having(
              (s) => s.workoutEntries.last.sets.single.weight,
              'untouched weight',
              100,
            ),
      ],
    );

    blocTest<WorkoutLogBloc, WorkoutLogState>(
      'workoutDurationChanged replaces the duration of the matching entry '
      'only',
      build: WorkoutLogBloc.new,
      seed: () => WorkoutLogState(
        workoutEntries: [
          WorkoutLogEntry(
            id: 'a',
            loggedAt: DateTime(2026, 6, 14),
            workoutGroupId: 'cardio',
            name: 'Run',
            type: WorkoutType.cardio,
            duration: const Duration(minutes: 20),
          ),
          WorkoutLogEntry(
            id: 'b',
            loggedAt: DateTime(2026, 6, 14),
            workoutGroupId: 'cardio',
            name: 'Row',
            type: WorkoutType.cardio,
            duration: const Duration(minutes: 10),
          ),
        ],
      ),
      act: (bloc) => bloc.add(
        const WorkoutLogEvent.workoutDurationChanged(
          'a',
          Duration(minutes: 30),
        ),
      ),
      expect: () => [
        isA<WorkoutLogState>()
            .having(
              (s) => s.workoutEntries.first.duration,
              'updated duration',
              const Duration(minutes: 30),
            )
            .having(
              (s) => s.workoutEntries.last.duration,
              'untouched duration',
              const Duration(minutes: 10),
            ),
      ],
    );

    test('toJson then fromJson round-trips the state', () {
      final bloc = WorkoutLogBloc();
      final state = WorkoutLogState(
        workoutEntries: [
          workoutLogEntry(id: 'a', loggedAt: DateTime(2026, 6, 14)),
        ],
      );

      expect(bloc.fromJson(bloc.toJson(state)), equals(state));
    });

    group('strengthProgress', () {
      WorkoutLogEntry strengthEntry({
        required String id,
        required DateTime loggedAt,
        required String name,
        String? usualWorkoutId,
        List<WorkoutSet> sets = const [WorkoutSet(weight: 100, reps: 8)],
      }) {
        return WorkoutLogEntry(
          id: id,
          loggedAt: loggedAt,
          workoutGroupId: 'push',
          name: name,
          sets: sets,
          usualWorkoutId: usualWorkoutId,
        );
      }

      test('one series per exercise with >=2 sessions, oldest point first', () {
        final state = WorkoutLogState(
          workoutEntries: [
            strengthEntry(
              id: '1',
              loggedAt: DateTime(2026, 6, 1, 9),
              name: 'Bench Press',
            ),
            strengthEntry(
              id: '2',
              loggedAt: DateTime(2026, 6, 8, 9),
              name: 'Bench Press',
              sets: const [WorkoutSet(weight: 105, reps: 8)],
            ),
          ],
        );

        final progress = state.strengthProgress(
          const TimeOfDay(hour: 0, minute: 0),
        );

        expect(progress, hasLength(1));
        expect(progress.single.name, equals('Bench Press'));
        expect(progress.single.points, hasLength(2));
        expect(
          progress.single.points.first.sessionDay,
          equals(DateTime(2026, 6)),
        );
        expect(
          progress.single.points.last.estimatedOneRepMax,
          closeTo(133.0, 0.5),
        );
      });

      test('drops exercises with fewer than two sessions', () {
        final state = WorkoutLogState(
          workoutEntries: [
            strengthEntry(
              id: '1',
              loggedAt: DateTime(2026, 6),
              name: 'Squat',
            ),
          ],
        );
        expect(
          state.strengthProgress(const TimeOfDay(hour: 0, minute: 0)),
          isEmpty,
        );
      });

      test('groups renamed usuals by usualWorkoutId into one series', () {
        final state = WorkoutLogState(
          workoutEntries: [
            strengthEntry(
              id: '1',
              loggedAt: DateTime(2026, 6),
              name: 'Bench',
              usualWorkoutId: 'u1',
            ),
            strengthEntry(
              id: '2',
              loggedAt: DateTime(2026, 6, 8),
              name: 'Bench Press',
              usualWorkoutId: 'u1',
            ),
          ],
        );

        final progress = state.strengthProgress(
          const TimeOfDay(hour: 0, minute: 0),
        );
        expect(progress, hasLength(1));
        // Display name comes from the most recent entry.
        expect(progress.single.name, equals('Bench Press'));
        expect(progress.single.points, hasLength(2));
      });

      test('excludes cardio entries', () {
        final state = WorkoutLogState(
          workoutEntries: [
            WorkoutLogEntry(
              id: '1',
              loggedAt: DateTime(2026, 6),
              workoutGroupId: 'cardio',
              name: 'Run',
              type: WorkoutType.cardio,
              duration: const Duration(minutes: 30),
            ),
            WorkoutLogEntry(
              id: '2',
              loggedAt: DateTime(2026, 6, 8),
              workoutGroupId: 'cardio',
              name: 'Run',
              type: WorkoutType.cardio,
              duration: const Duration(minutes: 35),
            ),
          ],
        );
        expect(
          state.strengthProgress(const TimeOfDay(hour: 0, minute: 0)),
          isEmpty,
        );
      });

      test('uses the strongest set across same-day entries for its point', () {
        const strongerSet = WorkoutSet(weight: 120, reps: 8);
        final state = WorkoutLogState(
          workoutEntries: [
            strengthEntry(
              id: '1',
              loggedAt: DateTime(2026, 6, 1, 9),
              name: 'Bench Press',
            ),
            strengthEntry(
              id: '2',
              loggedAt: DateTime(2026, 6, 1, 18),
              name: 'Bench Press',
              sets: const [strongerSet],
            ),
            strengthEntry(
              id: '3',
              loggedAt: DateTime(2026, 6, 8, 9),
              name: 'Bench Press',
              sets: const [WorkoutSet(weight: 110, reps: 8)],
            ),
          ],
        );

        final progress = state.strengthProgress(
          const TimeOfDay(hour: 0, minute: 0),
        );

        expect(progress, hasLength(1));
        expect(progress.single.points, hasLength(2));

        final jun1Point = progress.single.points.first;
        expect(jun1Point.sessionDay, equals(DateTime(2026, 6)));
        expect(jun1Point.topSet, equals(strongerSet));
        expect(
          jun1Point.estimatedOneRepMax,
          closeTo(strongerSet.estimatedOneRepMax, 0.001),
        );
      });

      test('canonical name is the most-recent entry regardless of list '
          'order', () {
        final state = WorkoutLogState(
          workoutEntries: [
            strengthEntry(
              id: '2',
              loggedAt: DateTime(2026, 6, 8),
              name: 'Bench Press',
              usualWorkoutId: 'u1',
            ),
            strengthEntry(
              id: '1',
              loggedAt: DateTime(2026, 6),
              name: 'Bench',
              usualWorkoutId: 'u1',
            ),
          ],
        );

        final progress = state.strengthProgress(
          const TimeOfDay(hour: 0, minute: 0),
        );

        expect(progress, hasLength(1));
        expect(progress.single.name, equals('Bench Press'));
      });

      test('sorts the most-recently-trained exercise first', () {
        final state = WorkoutLogState(
          workoutEntries: [
            strengthEntry(
              id: 'y1',
              loggedAt: DateTime(2026, 6),
              name: 'Squat',
            ),
            strengthEntry(
              id: 'y2',
              loggedAt: DateTime(2026, 6, 8),
              name: 'Squat',
            ),
            strengthEntry(
              id: 'x1',
              loggedAt: DateTime(2026, 6, 5),
              name: 'Bench Press',
            ),
            strengthEntry(
              id: 'x2',
              loggedAt: DateTime(2026, 6, 15),
              name: 'Bench Press',
            ),
          ],
        );

        final progress = state.strengthProgress(
          const TimeOfDay(hour: 0, minute: 0),
        );

        expect(progress, hasLength(2));
        expect(progress.first.name, equals('Bench Press'));
      });
    });
  });

  group(WorkoutLogState, () {
    WorkoutLogEntry workoutLogEntry(String id, DateTime loggedAt) {
      return WorkoutLogEntry(
        id: id,
        loggedAt: loggedAt,
        workoutGroupId: 'push',
        name: id,
        sets: const [WorkoutSet(weight: 100, reps: 10)], // volume 1000
      );
    }

    test('entriesOn returns only the entries on that logical day', () {
      final state = WorkoutLogState(
        workoutEntries: [
          workoutLogEntry('a', DateTime(2026, 6, 14, 18)),
          workoutLogEntry('b', DateTime(2026, 6, 15, 18)),
        ],
      );

      final entries = state.workoutEntries.entriesOn(
        DateTime(2026, 6, 14),
        dayStart,
      );

      expect(entries.single.id, equals('a'));
    });

    test("volumeOn sums the volume of that day's entries", () {
      final state = WorkoutLogState(
        workoutEntries: [
          workoutLogEntry('a', DateTime(2026, 6, 14, 8)),
          workoutLogEntry('b', DateTime(2026, 6, 14, 18)),
          workoutLogEntry('c', DateTime(2026, 6, 15, 18)),
        ],
      );

      expect(
        state.workoutEntries.volumeOn(DateTime(2026, 6, 14), dayStart),
        equals(2000.0),
      );
    });

    test('fromJson reads a newer, unknown version with the current schema', () {
      final state = WorkoutLogState.fromJson(<String, dynamic>{
        'version': 99,
        'workoutEntries': <dynamic>[],
      });

      expect(state.version, equals(99));
      expect(state.workoutEntries, isEmpty);
    });

    group('historyByMonth', () {
      WorkoutLogEntry entry(
        String id,
        DateTime loggedAt, {
        double weight = 100,
        int reps = 10,
      }) {
        return WorkoutLogEntry(
          id: id,
          loggedAt: loggedAt,
          workoutGroupId: 'push',
          name: id,
          sets: [WorkoutSet(weight: weight, reps: reps)],
        );
      }

      test('returns empty when no workouts have been logged', () {
        const state = WorkoutLogState();
        expect(state.historyByMonth(dayStart), isEmpty);
      });

      test('buckets entries into months with per-day volume and month '
          'average', () {
        // Two entries on May 14 (volume 1000 each = 2000 total for the day),
        // one entry on June 3 (volume 1000).
        final state = WorkoutLogState(
          workoutEntries: [
            entry('may-a', DateTime(2026, 5, 14, 8)),
            entry('may-b', DateTime(2026, 5, 14, 18)),
            entry('jun-a', DateTime(2026, 6, 3, 10)),
          ],
        );

        final months = state.historyByMonth(dayStart);

        // Oldest month first.
        expect(months.length, equals(2));
        expect(months[0].month, equals(DateTime(2026, 5)));
        expect(months[1].month, equals(DateTime(2026, 6)));

        // May: one day with volume = 2 * (100 * 10) = 2000.
        final mayMonth = months[0];
        expect(mayMonth.days.length, equals(1));
        expect(mayMonth.days[0].volume, equals(2000.0));
        expect(mayMonth.days[0].workoutEntries.length, equals(2));
        expect(mayMonth.averageVolume, equals(2000.0));

        // June: one day with volume = 100 * 10 = 1000.
        final juneMonth = months[1];
        expect(juneMonth.days.length, equals(1));
        expect(juneMonth.days[0].volume, equals(1000.0));
        expect(juneMonth.averageVolume, equals(1000.0));
      });
    });
  });
}
