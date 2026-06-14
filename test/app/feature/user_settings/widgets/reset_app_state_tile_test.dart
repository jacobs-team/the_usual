import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(ResetAppStateTile, () {
    GoRouter buildRouter() {
      return GoRouter(
        initialLocation: Routes.settings,
        routes: [
          GoRoute(
            path: Routes.settings,
            builder: (_, _) => const ResetAppStateTile(),
          ),
          GoRoute(
            path: Routes.onboarding,
            builder: (_, _) => const Text('onboarding-page'),
          ),
        ],
      );
    }

    testWidgets('cancelling the confirmation keeps the user on settings', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        const SizedBox.shrink(),
        router: buildRouter(),
      );

      await tester.tap(find.byType(SettingsNavRow));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('onboarding-page'), findsNothing);
    });

    testWidgets('confirming resets and returns to onboarding', (tester) async {
      await tester.pumpPumpPumpItUP(
        const SizedBox.shrink(),
        router: buildRouter(),
      );

      await tester.tap(find.byType(SettingsNavRow));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Reset'));
      await tester.pumpAndSettle();

      expect(find.text('onboarding-page'), findsOneWidget);
    });
  });
}
