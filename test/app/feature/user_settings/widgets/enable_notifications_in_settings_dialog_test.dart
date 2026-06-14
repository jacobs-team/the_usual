import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(EnableNotificationsInSettingsDialog, () {
    late NotificationService notificationService;

    setUp(() {
      notificationService = MockNotificationService();
      when(
        () => notificationService.openSystemSettings(),
      ).thenAnswer((_) async {});
    });

    Future<void> showDialogUnderTest(WidgetTester tester) async {
      await tester.pumpPumpPumpItUP(
        deps: [notificationService],
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => const EnableNotificationsInSettingsDialog(),
            ),
            child: const Text('open'),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    testWidgets('dismisses without opening settings on Not now', (
      tester,
    ) async {
      await showDialogUnderTest(tester);

      await tester.tap(find.text('Not now'));
      await tester.pumpAndSettle();

      expect(find.byType(EnableNotificationsInSettingsDialog), findsNothing);
      verifyNever(() => notificationService.openSystemSettings());
    });

    testWidgets('opens system settings on Open settings', (tester) async {
      await showDialogUnderTest(tester);

      await tester.tap(find.text('Open settings'));
      await tester.pumpAndSettle();

      verify(() => notificationService.openSystemSettings()).called(1);
    });
  });
}
