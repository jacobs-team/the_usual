import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(WorkoutLogEntry, () {
    test('volume sums the volume of every set', () {
      final workoutLogEntry = WorkoutLogEntry(
        id: 'w1',
        loggedAt: DateTime(2026, 6, 23, 18),
        workoutGroupId: 'push',
        name: 'Bench Press',
        sets: const [
          WorkoutSet(weight: 135, reps: 8), // 1080
          WorkoutSet(weight: 145, reps: 6), // 870
        ],
      );

      expect(workoutLogEntry.volume, equals(1950.0));
    });

    test('volume is zero with no sets', () {
      final workoutLogEntry = WorkoutLogEntry(
        id: 'w1',
        loggedAt: DateTime(2026, 6, 23, 18),
        workoutGroupId: 'push',
        name: 'Plank',
      );

      expect(workoutLogEntry.volume, equals(0.0));
    });

    test('round-trips through json', () {
      final workoutLogEntry = WorkoutLogEntry(
        id: 'w1',
        loggedAt: DateTime(2026, 6, 23, 18),
        workoutGroupId: 'push',
        name: 'Bench Press',
        usualWorkoutId: 'usual-1',
        sets: const [WorkoutSet(weight: 135, reps: 8)],
      );

      expect(
        WorkoutLogEntry.fromJson(workoutLogEntry.toJson()),
        equals(workoutLogEntry),
      );
    });
  });
}
