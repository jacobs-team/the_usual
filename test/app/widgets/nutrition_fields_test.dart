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

    String fieldText(WidgetTester tester, int index) =>
        tester.widget<TextField>(
          find
              .descendant(of: fieldAt(index), matching: find.byType(TextField))
              .first,
        ).controller!.text;

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

      expect(fieldText(tester, 0), equals('380'));
      expect(fieldText(tester, 1), equals('30'));
      expect(fieldText(tester, 2), equals('40'));
      expect(fieldText(tester, 3), equals('12'));
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

    testWidgets('updates the fields when the initial nutrition changes', (
      tester,
    ) async {
      var initial = const Nutrition();
      await tester.pumpPumpPumpItUP(
        StatefulBuilder(
          builder: (context, setState) => Column(
            children: [
              NutritionFields(initial: initial, onChanged: (_) {}),
              ElevatedButton(
                key: const Key('estimate-button'),
                onPressed: () => setState(
                  () => initial = const Nutrition(
                    calories: 350,
                    protein: 30,
                    carbs: 40,
                    fat: 12,
                  ),
                ),
                child: const Text('estimate'),
              ),
            ],
          ),
        ),
      );

      expect(fieldText(tester, 0), isEmpty);

      await tester.tap(find.byKey(const Key('estimate-button')));
      await tester.pump();

      expect(fieldText(tester, 0), equals('350'));
      expect(fieldText(tester, 1), equals('30'));
      expect(fieldText(tester, 2), equals('40'));
      expect(fieldText(tester, 3), equals('12'));
    });

    testWidgets('keeps what the user types when the value echoes back', (
      tester,
    ) async {
      // Mirrors the form's round-trip: the parsed value is fed straight back
      // in as the new initial. The field must not be cleared or reset.
      var initial = const Nutrition();
      await tester.pumpPumpPumpItUP(
        StatefulBuilder(
          builder: (context, setState) => NutritionFields(
            initial: initial,
            onChanged: (value) => setState(() => initial = value),
          ),
        ),
      );

      await tester.enterText(fieldAt(0), '380');
      await tester.pump();

      expect(fieldText(tester, 0), equals('380'));
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
