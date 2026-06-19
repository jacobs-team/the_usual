import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(TheUsualTextField, () {
    testWidgets('renders an outlined field by default', (tester) async {
      await tester.pumpPumpPumpItUP(
        const TheUsualTextField(hintText: 'Name'),
      );

      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('renders a dense field without an outline', (tester) async {
      await tester.pumpPumpPumpItUP(
        const TheUsualTextField(dense: true),
      );

      final field = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(field, isNotNull);
    });

    testWidgets('wraps in a SizedBox when a width is given', (tester) async {
      await tester.pumpPumpPumpItUP(
        const TheUsualTextField(width: 120),
      );

      expect(
        find.ancestor(
          of: find.byType(TextFormField),
          matching: find.byType(SizedBox),
        ),
        findsWidgets,
      );
    });

    testWidgets('wraps in an IntrinsicWidth when autoSize is set', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        const TheUsualTextField(autoSize: true),
      );

      expect(find.byType(IntrinsicWidth), findsOneWidget);
    });

    testWidgets('reports text changes through onChanged', (tester) async {
      String? changed;
      await tester.pumpPumpPumpItUP(
        TheUsualTextField(onChanged: (value) => changed = value),
      );

      await tester.enterText(find.byType(TextFormField), 'hello');

      expect(changed, equals('hello'));
    });

    testWidgets('reports submission through onSubmitted', (tester) async {
      String? submitted;
      await tester.pumpPumpPumpItUP(
        TheUsualTextField(onSubmitted: (value) => submitted = value),
      );

      await tester.enterText(find.byType(TextFormField), 'done');
      await tester.testTextInput.receiveAction(TextInputAction.done);

      expect(submitted, equals('done'));
    });

    testWidgets('unfocuses on submit when no onSubmitted is given', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        const TheUsualTextField(autofocus: true),
      );

      await tester.enterText(find.byType(TextFormField), 'x');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });
}
