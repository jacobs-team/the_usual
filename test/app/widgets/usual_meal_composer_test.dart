import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(UsualMealComposer, () {
    testWidgets('adds a meal with name and calories from the add button', (
      tester,
    ) async {
      String? name;
      int? calories;
      await tester.pumpPumpPumpItUP(
        UsualMealComposer(
          onAdd: (n, c) {
            name = n;
            calories = c;
          },
        ),
      );

      await tester.enterText(find.byType(TextFormField).first, 'Eggs');
      await tester.enterText(find.byType(TextFormField).last, '350');
      await tester.tap(find.byIcon(Icons.add));

      expect(name, equals('Eggs'));
      expect(calories, equals(350));
    });

    testWidgets('clears the fields after adding', (tester) async {
      await tester.pumpPumpPumpItUP(
        UsualMealComposer(onAdd: (_, _) {}),
      );

      await tester.enterText(find.byType(TextFormField).first, 'Eggs');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('Eggs'), findsNothing);
    });

    testWidgets('ignores submission with a blank name', (tester) async {
      var added = false;
      await tester.pumpPumpPumpItUP(
        UsualMealComposer(onAdd: (_, _) => added = true),
      );

      await tester.tap(find.byIcon(Icons.add));

      expect(added, isFalse);
    });

    testWidgets('submitting the name field advances to calories', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        UsualMealComposer(onAdd: (_, _) {}),
      );

      await tester.enterText(find.byType(TextFormField).first, 'Eggs');
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('submitting the calories field adds the meal', (tester) async {
      var added = false;
      await tester.pumpPumpPumpItUP(
        UsualMealComposer(onAdd: (_, _) => added = true),
      );

      await tester.enterText(find.byType(TextFormField).first, 'Eggs');
      await tester.enterText(find.byType(TextFormField).last, '350');
      await tester.testTextInput.receiveAction(TextInputAction.done);

      expect(added, isTrue);
    });
  });
}
