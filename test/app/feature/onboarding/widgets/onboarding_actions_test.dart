import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(OnboardingActions, () {
    testWidgets('renders the primary action only', (tester) async {
      await tester.pumpPumpPumpItUP(
        const OnboardingActions(
          primary: SizedBox(key: Key('primary')),
        ),
      );

      expect(find.byKey(const Key('primary')), findsOneWidget);
    });

    testWidgets('renders the above and secondary slots when given', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        const OnboardingActions(
          primary: SizedBox(key: Key('primary')),
          secondary: SizedBox(key: Key('secondary')),
          above: SizedBox(key: Key('above')),
        ),
      );

      expect(find.byKey(const Key('primary')), findsOneWidget);
      expect(find.byKey(const Key('secondary')), findsOneWidget);
      expect(find.byKey(const Key('above')), findsOneWidget);
    });
  });
}
