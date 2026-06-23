import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(WorkoutSet, () {
    test('volume multiplies weight by reps', () {
      const workoutSet = WorkoutSet(weight: 135, reps: 8);

      expect(workoutSet.volume, equals(1080.0));
    });

    test('volume is zero when weight or reps is unset', () {
      expect(const WorkoutSet(reps: 8).volume, equals(0.0));
      expect(const WorkoutSet(weight: 135).volume, equals(0.0));
      expect(const WorkoutSet().volume, equals(0.0));
    });

    test('round-trips through json', () {
      const workoutSet = WorkoutSet(
        weight: 142.5,
        reps: 6,
        weightAutoEstimated: true,
      );

      expect(WorkoutSet.fromJson(workoutSet.toJson()), equals(workoutSet));
    });

    test('defaults weightAutoEstimated to false', () {
      expect(const WorkoutSet().weightAutoEstimated, isFalse);
    });
  });
}
