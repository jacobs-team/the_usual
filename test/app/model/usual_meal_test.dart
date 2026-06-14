import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(UsualMeal, () {
    test('round-trips through json', () {
      const usualMeal = UsualMeal(
        id: 'usual-1',
        name: 'Oatmeal',
        photoPath: '/tmp/oat.png',
        calories: 300,
      );

      final decoded = UsualMeal.fromJson(usualMeal.toJson());

      expect(decoded, equals(usualMeal));
    });

    test('parses optional fields as null when absent', () {
      final usualMeal = UsualMeal.fromJson(<String, dynamic>{
        'id': 'usual-2',
        'name': 'Apple',
      });

      expect(usualMeal.calories, isNull);
      expect(usualMeal.photoPath, isNull);
    });
  });
}
