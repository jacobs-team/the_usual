import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(AiMealSuggestion, () {
    test('round-trips through json', () {
      const aiMealSuggestion = AiMealSuggestion(
        name: '2 eggs & sourdough toast',
        quantity: 2.5,
        nutrition: Nutrition(calories: 350, protein: 18, fat: 14, carbs: 30),
      );

      final decoded = AiMealSuggestion.fromJson(aiMealSuggestion.toJson());

      expect(decoded, equals(aiMealSuggestion));
    });

    test('uses defaults for quantity and nutrition when absent', () {
      final aiMealSuggestion = AiMealSuggestion.fromJson(<String, dynamic>{
        'name': 'Apple',
      });

      expect(aiMealSuggestion.name, equals('Apple'));
      expect(aiMealSuggestion.quantity, equals(1.0));
      expect(aiMealSuggestion.nutrition, equals(const Nutrition()));
    });

    test('parses a whole-number quantity as a double', () {
      final aiMealSuggestion = AiMealSuggestion.fromJson(<String, dynamic>{
        'name': '3 protein bars',
        'quantity': 3,
      });

      expect(
        aiMealSuggestion.quantity,
        isA<double>().having((q) => q, 'value', equals(3.0)),
      );
    });

    test('constructs with the default quantity and nutrition', () {
      const aiMealSuggestion = AiMealSuggestion(name: 'Banana');

      expect(aiMealSuggestion.quantity, equals(1.0));
      expect(aiMealSuggestion.nutrition, equals(const Nutrition()));
    });
  });
}
