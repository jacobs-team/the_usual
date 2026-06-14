import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(MealCheckinScheduleMode, () {
    test('exposes a display label for each mode', () {
      expect(MealCheckinScheduleMode.perMeal.label, equals('After each meal'));
      expect(MealCheckinScheduleMode.endOfDay.label, equals('Once a day'));
    });
  });
}
