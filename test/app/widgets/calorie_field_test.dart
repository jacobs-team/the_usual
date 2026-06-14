import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(CalorieField, () {
    testWidgets('renders without callbacks', (tester) async {
      await tester.pumpPumpPumpItUP(const CalorieField());

      expect(find.byType(CalorieField), findsOneWidget);
      expect(find.byType(TheUsualTextField), findsOneWidget);
    });

    testWidgets('parses entered digits to an int for onChanged', (
      tester,
    ) async {
      int? changed;
      await tester.pumpPumpPumpItUP(
        CalorieField(onChanged: (value) => changed = value),
      );

      await tester.enterText(find.byType(TextFormField), '350');

      expect(changed, equals(350));
    });

    testWidgets('parses entered digits to an int for onSubmitted', (
      tester,
    ) async {
      int? submitted;
      await tester.pumpPumpPumpItUP(
        CalorieField(onSubmitted: (value) => submitted = value),
      );

      await tester.enterText(find.byType(TextFormField), '420');
      await tester.testTextInput.receiveAction(TextInputAction.done);

      expect(submitted, equals(420));
    });
  });
}
