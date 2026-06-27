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

    test('estimatedOneRepMax uses Epley for 2..12 reps', () {
      // 100 * (1 + 8/30) = 126.666...
      expect(
        const WorkoutSet(weight: 100, reps: 8).estimatedOneRepMax,
        closeTo(126.6667, 0.001),
      );
    });

    test('estimatedOneRepMax returns raw weight for a single rep', () {
      expect(
        const WorkoutSet(weight: 140, reps: 1).estimatedOneRepMax,
        equals(140),
      );
    });

    test('estimatedOneRepMax falls back to raw weight above 12 reps', () {
      expect(
        const WorkoutSet(weight: 60, reps: 20).estimatedOneRepMax,
        equals(60),
      );
    });

    test('estimatedOneRepMax is 0 when weight or reps is missing', () {
      expect(const WorkoutSet(reps: 8).estimatedOneRepMax, equals(0));
      expect(const WorkoutSet(weight: 100).estimatedOneRepMax, equals(0));
      expect(const WorkoutSet().estimatedOneRepMax, equals(0));
    });
  });
}
