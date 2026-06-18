import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(NutritionFields, () {
    Finder fieldAt(int index) => find
        .descendant(
          of: find.byType(NutritionFields),
          matching: find.byType(TextFormField),
        )
        .at(index);

    testWidgets('seeds the fields from the initial nutrition', (tester) async {
      await tester.pumpPumpPumpItUP(
        NutritionFields(
          initial: const Nutrition(
            calories: 380,
            protein: 30,
            fat: 12,
            carbs: 40,
          ),
          onChanged: (_) {},
        ),
      );

      expect(find.text('380'), findsOneWidget);
      expect(find.text('30'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.text('40'), findsOneWidget);
    });

    testWidgets('emits parsed nutrition as each field changes', (tester) async {
      Nutrition? changed;
      await tester.pumpPumpPumpItUP(
        NutritionFields(onChanged: (value) => changed = value),
      );

      await tester.enterText(fieldAt(0), '380');
      expect(changed, equals(const Nutrition(calories: 380)));

      await tester.enterText(fieldAt(1), '30');
      expect(changed, equals(const Nutrition(calories: 380, protein: 30)));

      await tester.enterText(fieldAt(2), '12');
      expect(
        changed,
        equals(const Nutrition(calories: 380, protein: 30, carbs: 12)),
      );

      await tester.enterText(fieldAt(3), '40');
      expect(
        changed,
        equals(
          const Nutrition(calories: 380, protein: 30, carbs: 12, fat: 40),
        ),
      );
    });

    testWidgets('dense mode renders all four fields', (tester) async {
      await tester.pumpPumpPumpItUP(
        NutritionFields(dense: true, onChanged: (_) {}),
      );

      expect(
        find.descendant(
          of: find.byType(NutritionFields),
          matching: find.byType(TextFormField),
        ),
        findsNWidgets(4),
      );
    });
  });
}
