import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(UsualWorkout, () {
    test('round-trips through json', () {
      const usualWorkout = UsualWorkout(
        id: 'usual-1',
        name: 'Bench Press',
        sets: [
          WorkoutSet(weight: 135, reps: 8),
          WorkoutSet(weight: 145, reps: 6),
        ],
      );

      expect(
        UsualWorkout.fromJson(usualWorkout.toJson()),
        equals(usualWorkout),
      );
    });

    test('defaults sets to empty when absent', () {
      final usualWorkout = UsualWorkout.fromJson(<String, dynamic>{
        'id': 'usual-2',
        'name': 'Squat',
      });

      expect(usualWorkout.sets, isEmpty);
    });

    test('round-trips a non-null duration', () {
      const usualWorkout = UsualWorkout(
        id: 'usual-3',
        name: 'Plank',
        duration: Duration(minutes: 2),
      );

      expect(
        UsualWorkout.fromJson(usualWorkout.toJson()).duration,
        equals(const Duration(minutes: 2)),
      );
    });
  });
}
