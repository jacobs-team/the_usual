import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(FoodDraft, () {
    test('has sensible defaults', () {
      const draft = FoodDraft(id: 'a');
      expect(draft.name, isEmpty);
      expect(draft.quantity, equals(1.0));
      expect(draft.nutrition, equals(const Nutrition()));
      expect(draft.addToUsualMeals, isFalse);
    });

    test('copyWith updates a single field', () {
      const draft = FoodDraft(id: 'a');
      expect(draft.copyWith(name: 'Toast').name, equals('Toast'));
    });

    test('usualFoodId defaults to null and is settable', () {
      const foodDraft = FoodDraft(id: 'd1');
      expect(foodDraft.usualFoodId, isNull);
      expect(foodDraft.copyWith(usualFoodId: 'f1').usualFoodId, equals('f1'));
    });
  });
}
