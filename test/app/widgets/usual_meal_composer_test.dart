import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(UsualMealComposer, () {
    testWidgets('adds a meal with name and nutrition from the add button', (
      tester,
    ) async {
      String? name;
      Nutrition? nutrition;
      await tester.pumpPumpPumpItUP(
        UsualMealComposer(
          onAdd: (n, nutr) {
            name = n;
            nutrition = nutr;
          },
        ),
      );

      await tester.enterText(find.byType(TextFormField).first, 'Eggs');
      // The first nutrition field is calories; the name field is index 0.
      await tester.enterText(find.byType(TextFormField).at(1), '350');
      await tester.tap(find.byIcon(Icons.add));

      expect(name, equals('Eggs'));
      expect(nutrition?.calories, equals(350));
    });

    testWidgets('clears the fields after adding', (tester) async {
      await tester.pumpPumpPumpItUP(
        UsualMealComposer(onAdd: (_, _) {}),
      );

      await tester.enterText(find.byType(TextFormField).first, 'Eggs');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      final nameField = tester.widget<TextField>(
        find
            .descendant(
              of: find.byType(TextFormField).first,
              matching: find.byType(TextField),
            )
            .first,
      );
      expect(nameField.controller!.text, isEmpty);
    });

    testWidgets('ignores submission with a blank name', (tester) async {
      var added = false;
      await tester.pumpPumpPumpItUP(
        UsualMealComposer(onAdd: (_, _) => added = true),
      );

      await tester.tap(find.byIcon(Icons.add));

      expect(added, isFalse);
    });
  });
}
