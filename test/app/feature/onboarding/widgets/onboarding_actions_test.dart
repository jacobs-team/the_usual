import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(OnboardingActions, () {
    testWidgets('renders the primary action only', (tester) async {
      await tester.pumpPumpPumpItUP(
        const OnboardingActions(
          primary: Text('primary'),
        ),
      );

      expect(find.text('primary'), findsOneWidget);
    });

    testWidgets('renders the above and secondary slots when given', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        const OnboardingActions(
          primary: Text('primary'),
          secondary: Text('secondary'),
          above: Text('above'),
        ),
      );

      expect(find.text('primary'), findsOneWidget);
      expect(find.text('secondary'), findsOneWidget);
      expect(find.text('above'), findsOneWidget);
    });
  });
}
