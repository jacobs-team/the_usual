import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group('WorkoutSetFormatting', () {
    test('label is weight×reps', () {
      expect(const WorkoutSet(weight: 135, reps: 8).label, equals('135×8'));
    });

    test('label trims a whole-number weight and shows — for missing '
        'values', () {
      expect(const WorkoutSet(weight: 142.5, reps: 6).label, equals('142.5×6'));
      expect(const WorkoutSet(reps: 8).label, equals('—×8'));
      expect(const WorkoutSet(weight: 100).label, equals('100×—'));
    });
  });

  group('WorkoutSetListFormatting', () {
    test('totalVolume sums set volumes', () {
      const sets = [
        WorkoutSet(weight: 135, reps: 8),
        WorkoutSet(weight: 145, reps: 6),
      ];
      expect(sets.totalVolume, equals(1950.0));
    });

    test('summary lists count and each set', () {
      const sets = [
        WorkoutSet(weight: 135, reps: 8),
        WorkoutSet(weight: 145, reps: 6),
      ];
      expect(sets.summary, equals('2 sets · 135×8, 145×6'));
    });

    test('summary uses singular for one set and a fallback when empty', () {
      expect(
        const [WorkoutSet(weight: 100, reps: 5)].summary,
        equals('1 set · 100×5'),
      );
      expect(const <WorkoutSet>[].summary, equals('No sets'));
    });
  });

  group('WorkoutSetListFormatting e1RM', () {
    test('topEstimatedOneRepMaxSet picks the highest-estimate set', () {
      // 100x8 -> 126.7 ; 110x5 -> 128.3 (winner) ; 120x1 -> 120
      const sets = [
        WorkoutSet(weight: 100, reps: 8),
        WorkoutSet(weight: 110, reps: 5),
        WorkoutSet(weight: 120, reps: 1),
      ];
      expect(
        sets.topEstimatedOneRepMaxSet,
        equals(const WorkoutSet(weight: 110, reps: 5)),
      );
      expect(sets.bestEstimatedOneRepMax, closeTo(128.333, 0.01));
    });

    test('ignores sets with no computable estimate', () {
      const sets = [WorkoutSet(reps: 8), WorkoutSet(weight: 80, reps: 6)];
      expect(
        sets.topEstimatedOneRepMaxSet,
        equals(const WorkoutSet(weight: 80, reps: 6)),
      );
    });

    test('returns null/0 when no set has weight and reps', () {
      const sets = [WorkoutSet(weight: 80), WorkoutSet(reps: 5)];
      expect(sets.topEstimatedOneRepMaxSet, isNull);
      expect(sets.bestEstimatedOneRepMax, equals(0));
    });
  });

  group('WorkoutSetListFormatting differsInWeightOrReps', () {
    test('true when the set counts differ', () {
      const a = [WorkoutSet(weight: 100, reps: 8)];
      const b = [
        WorkoutSet(weight: 100, reps: 8),
        WorkoutSet(weight: 100, reps: 8),
      ];
      expect(a.differsInWeightOrReps(b), isTrue);
    });

    test('true when a weight or reps value differs', () {
      const a = [WorkoutSet(weight: 100, reps: 8)];
      const differentWeight = [WorkoutSet(weight: 105, reps: 8)];
      const differentReps = [WorkoutSet(weight: 100, reps: 6)];
      expect(a.differsInWeightOrReps(differentWeight), isTrue);
      expect(a.differsInWeightOrReps(differentReps), isTrue);
    });

    test('false when weight and reps match, ignoring the auto-estimate '
        'flag', () {
      const a = [WorkoutSet(weight: 100, reps: 8)];
      const sameButAutoEstimated = [
        WorkoutSet(weight: 100, reps: 8, weightAutoEstimated: true),
      ];
      expect(a.differsInWeightOrReps(sameButAutoEstimated), isFalse);
    });
  });

  group('WorkoutLogEntryListFormatting', () {
    const dayStart = TimeOfDay(hour: 0, minute: 0);

    WorkoutLogEntry entry({
      required String id,
      required DateTime loggedAt,
      String workoutGroupId = 'push',
      String? name,
      String? usualWorkoutId,
    }) {
      return WorkoutLogEntry(
        id: id,
        loggedAt: loggedAt,
        workoutGroupId: workoutGroupId,
        name: name ?? id,
        sets: const [WorkoutSet(weight: 100, reps: 10)], // 1000
        usualWorkoutId: usualWorkoutId,
      );
    }

    UsualWorkout usual(String id, String name) =>
        UsualWorkout(id: id, name: name);

    test('totalVolume sums entry volumes', () {
      final entries = [
        WorkoutLogEntry(
          id: 'a',
          loggedAt: DateTime(2026, 6, 23),
          workoutGroupId: 'push',
          name: 'Bench',
          sets: const [WorkoutSet(weight: 100, reps: 10)], // 1000
        ),
        WorkoutLogEntry(
          id: 'b',
          loggedAt: DateTime(2026, 6, 23),
          workoutGroupId: 'push',
          name: 'OHP',
          sets: const [WorkoutSet(weight: 50, reps: 10)], // 500
        ),
      ];
      expect(entries.totalVolume, equals(1500.0));
    });

    group('orderedQuickPicks', () {
      test('puts the most recently logged usual first, then orders the rest '
          'by how often they were logged in the group', () {
        // Bench logged twice (older), OHP logged once (most recent).
        final entries = [
          entry(
            id: 'b1',
            loggedAt: DateTime(2026, 6),
            name: 'Bench',
            usualWorkoutId: 'bench',
          ),
          entry(
            id: 'b2',
            loggedAt: DateTime(2026, 6, 5),
            name: 'Bench',
            usualWorkoutId: 'bench',
          ),
          entry(
            id: 'o1',
            loggedAt: DateTime(2026, 6, 10),
            name: 'OHP',
            usualWorkoutId: 'ohp',
          ),
        ];
        final usuals = [
          usual('bench', 'Bench'),
          usual('ohp', 'OHP'),
          usual('fly', 'Fly'),
        ];

        final picks = entries.orderedQuickPicks(
          workoutGroupId: 'push',
          usuals: usuals,
          day: DateTime(2026, 6, 20),
          dayStart: dayStart,
        );

        // OHP is most recent, then Bench (more logs), then Fly (never logged).
        expect(picks.map((u) => u.id), equals(['ohp', 'bench', 'fly']));
      });

      test('drops usuals already logged on the day, matched by name or id', () {
        final entries = [
          entry(
            id: 'today-bench',
            loggedAt: DateTime(2026, 6, 20, 10),
            name: 'Bench',
            usualWorkoutId: 'bench',
          ),
          entry(
            id: 'today-fly',
            loggedAt: DateTime(2026, 6, 20, 10),
            name: 'Fly',
          ),
        ];
        final usuals = [
          usual('bench', 'Bench'),
          usual('fly', 'Fly'),
          usual('ohp', 'OHP'),
        ];

        final picks = entries.orderedQuickPicks(
          workoutGroupId: 'push',
          usuals: usuals,
          day: DateTime(2026, 6, 20),
          dayStart: dayStart,
        );

        // Bench hidden by id, Fly hidden by name; only OHP remains.
        expect(picks.map((u) => u.id), equals(['ohp']));
      });

      test('breaks log-count ties by most recent, then original order', () {
        // bench and ohp each logged once (tie on count); ohp logged more
        // recently. fly never logged.
        final entries = [
          entry(
            id: 'b1',
            loggedAt: DateTime(2026, 6),
            name: 'Bench',
            usualWorkoutId: 'bench',
          ),
          entry(
            id: 'o1',
            loggedAt: DateTime(2026, 6, 3),
            name: 'OHP',
            usualWorkoutId: 'ohp',
          ),
        ];
        // Order the usuals so fly (never logged) sits between the two logged
        // ones, exercising the original-index tiebreaker for unlogged usuals.
        final usuals = [
          usual('bench', 'Bench'),
          usual('fly', 'Fly'),
          usual('ohp', 'OHP'),
          usual('raise', 'Raise'),
        ];

        final picks = entries.orderedQuickPicks(
          workoutGroupId: 'push',
          usuals: usuals,
          day: DateTime(2026, 6, 20),
          dayStart: dayStart,
        );

        // ohp is most recent overall (placed first). Of the remaining, ohp is
        // gone; bench (logged) ranks above the never-logged fly and raise,
        // which keep their original relative order.
        expect(picks.first.id, equals('ohp'));
        expect(
          picks.map((u) => u.id),
          equals(['ohp', 'bench', 'fly', 'raise']),
        );
      });

      test('orders equal-count remaining usuals by most recent, with logged '
          'ahead of never-logged', () {
        // Three logged usuals each logged exactly once: recent (newest, becomes
        // mostRecent), then olderA and olderB which remain with equal counts
        // but different last-logged times. A fourth usual is never logged.
        final entries = [
          entry(
            id: 'r1',
            loggedAt: DateTime(2026, 6, 15),
            name: 'Recent',
            usualWorkoutId: 'recent',
          ),
          entry(
            id: 'a1',
            loggedAt: DateTime(2026, 6, 5),
            name: 'OlderA',
            usualWorkoutId: 'olderA',
          ),
          entry(
            id: 'b1',
            loggedAt: DateTime(2026, 6, 10),
            name: 'OlderB',
            usualWorkoutId: 'olderB',
          ),
        ];
        final usuals = [
          usual('recent', 'Recent'),
          usual('olderA', 'OlderA'),
          usual('olderB', 'OlderB'),
          usual('never', 'Never'),
        ];

        final picks = entries.orderedQuickPicks(
          workoutGroupId: 'push',
          usuals: usuals,
          day: DateTime(2026, 6, 20),
          dayStart: dayStart,
        );

        // recent first (most recent overall), then olderB before olderA (more
        // recent of the equal-count pair), then never-logged last.
        expect(
          picks.map((u) => u.id),
          equals(['recent', 'olderB', 'olderA', 'never']),
        );
      });

      test('ignores entries from other groups and unlinked entries', () {
        final entries = [
          entry(
            id: 'other-group',
            loggedAt: DateTime(2026, 6, 10),
            workoutGroupId: 'legs',
            name: 'Squat',
            usualWorkoutId: 'squat',
          ),
          entry(
            id: 'unlinked',
            loggedAt: DateTime(2026, 6, 11),
            name: 'Bench',
          ),
        ];
        final usuals = [usual('bench', 'Bench')];

        final picks = entries.orderedQuickPicks(
          workoutGroupId: 'push',
          usuals: usuals,
          day: DateTime(2026, 6, 20),
          dayStart: dayStart,
        );

        // No logs counted toward push, so the single usual just passes through.
        expect(picks.map((u) => u.id), equals(['bench']));
      });
    });

    group('previousSessionWorkouts', () {
      test('returns the entries from the most recent prior session, '
          'excluding any already logged on the day', () {
        final entries = [
          // Older session: two exercises.
          entry(
            id: 'old-bench',
            loggedAt: DateTime(2026, 6, 5),
            name: 'Bench',
          ),
          entry(
            id: 'old-fly',
            loggedAt: DateTime(2026, 6, 5),
            name: 'Fly',
          ),
          // More recent prior session: Bench + OHP.
          entry(
            id: 'recent-bench',
            loggedAt: DateTime(2026, 6, 12),
            name: 'Bench',
            usualWorkoutId: 'bench',
          ),
          entry(
            id: 'recent-ohp',
            loggedAt: DateTime(2026, 6, 12),
            name: 'OHP',
          ),
          // Already logged today: Bench by id.
          entry(
            id: 'today-bench',
            loggedAt: DateTime(2026, 6, 20, 9),
            name: 'Bench',
            usualWorkoutId: 'bench',
          ),
        ];

        final previous = entries.previousSessionWorkouts(
          workoutGroupId: 'push',
          day: DateTime(2026, 6, 20),
          dayStart: dayStart,
        );

        // Most recent prior session is Jun 12; Bench excluded as already
        // logged today, leaving OHP.
        expect(previous.map((e) => e.id), equals(['recent-ohp']));
      });

      test('excludes by name when an entry already logged today shares a '
          'name', () {
        final entries = [
          entry(
            id: 'prev-bench',
            loggedAt: DateTime(2026, 6, 12),
            name: 'Bench',
          ),
          entry(
            id: 'today-bench',
            loggedAt: DateTime(2026, 6, 20, 9),
            name: 'Bench',
          ),
        ];

        final previous = entries.previousSessionWorkouts(
          workoutGroupId: 'push',
          day: DateTime(2026, 6, 20),
          dayStart: dayStart,
        );

        expect(previous, isEmpty);
      });

      test('excludes a prior entry by linked id even when its name differs '
          'from the entry logged today', () {
        final entries = [
          // Prior session entry under an old name, linked to usual 'bench'.
          entry(
            id: 'prev',
            loggedAt: DateTime(2026, 6, 12),
            name: 'Bench',
            usualWorkoutId: 'bench',
          ),
          // Today's entry: renamed, but the same linked id.
          entry(
            id: 'today',
            loggedAt: DateTime(2026, 6, 20, 9),
            name: 'Barbell Bench Press',
            usualWorkoutId: 'bench',
          ),
        ];

        final previous = entries.previousSessionWorkouts(
          workoutGroupId: 'push',
          day: DateTime(2026, 6, 20),
          dayStart: dayStart,
        );

        // Names differ, so only the id match hides the prior entry.
        expect(previous, isEmpty);
      });

      test('returns empty when the group has no earlier session', () {
        final entries = [
          entry(
            id: 'today',
            loggedAt: DateTime(2026, 6, 20, 9),
            name: 'Bench',
          ),
        ];

        final previous = entries.previousSessionWorkouts(
          workoutGroupId: 'push',
          day: DateTime(2026, 6, 20),
          dayStart: dayStart,
        );

        expect(previous, isEmpty);
      });
    });
  });
}
