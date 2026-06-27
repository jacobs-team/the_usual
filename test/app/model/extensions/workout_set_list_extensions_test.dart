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

  group('WorkoutLogEntryListFormatting', () {
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
  });
}
