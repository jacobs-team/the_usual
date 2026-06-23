import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(WorkoutGroup, () {
    test('round-trips through json', () {
      const workoutGroup = WorkoutGroup(id: 'push', name: 'Push', order: 0);

      expect(
        WorkoutGroup.fromJson(workoutGroup.toJson()),
        equals(workoutGroup),
      );
    });
  });
}
