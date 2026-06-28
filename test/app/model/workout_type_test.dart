import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(WorkoutType, () {
    test('label reads Strength and Cardio', () {
      expect(WorkoutType.strength.label, equals('Strength'));
      expect(WorkoutType.cardio.label, equals('Cardio'));
    });

    group('defaultForGroupName', () {
      test('defaults to strength for an unknown group name', () {
        expect(
          WorkoutType.defaultForGroupName('Push Day'),
          equals(WorkoutType.strength),
        );
      });

      test('matches a single-word cardio term as a whole word, '
          'case-insensitively', () {
        expect(
          WorkoutType.defaultForGroupName('Morning Run'),
          equals(WorkoutType.cardio),
        );
        expect(
          WorkoutType.defaultForGroupName('CARDIO'),
          equals(WorkoutType.cardio),
        );
      });

      test('does not match a single-word term embedded in a larger word', () {
        // "run" must not match inside "errands".
        expect(
          WorkoutType.defaultForGroupName('errands'),
          equals(WorkoutType.strength),
        );
      });

      test('matches a multi-word cardio term anywhere in the name', () {
        expect(
          WorkoutType.defaultForGroupName('Evening spin class session'),
          equals(WorkoutType.cardio),
        );
      });
    });
  });
}
