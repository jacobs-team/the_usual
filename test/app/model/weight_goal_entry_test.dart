import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(WeightGoalEntry, () {
    test('round-trips through json', () {
      final weightGoalEntry = WeightGoalEntry(
        effectiveFrom: DateTime.fromMillisecondsSinceEpoch(0),
        weightUnit: WeightUnit.kg,
        weight: 72.5,
      );

      final decoded = WeightGoalEntry.fromJson(weightGoalEntry.toJson());

      expect(decoded, equals(weightGoalEntry));
    });

    test('reads a null weight as a cleared goal', () {
      final weightGoalEntry = WeightGoalEntry(
        effectiveFrom: DateTime.fromMillisecondsSinceEpoch(0),
        weightUnit: WeightUnit.lb,
      );

      final decoded = WeightGoalEntry.fromJson(weightGoalEntry.toJson());

      expect(decoded.weight, isNull);
    });
  });
}
