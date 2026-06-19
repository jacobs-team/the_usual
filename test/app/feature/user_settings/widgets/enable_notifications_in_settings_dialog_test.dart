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
            key: const Key('open-dialog-button'),
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => const EnableNotificationsInSettingsDialog(),
            ),
            child: const Text('open'),
          ),
        ),
      );
      await tester.tap(find.byKey(const Key('open-dialog-button')));
      await tester.pumpAndSettle();
    }

    testWidgets('dismisses without opening settings on the dismiss action', (
      tester,
    ) async {
      await showDialogUnderTest(tester);

      // The dismiss action is the dialog's TextButton; the confirm action is a
      // FilledButton.
      await tester.tap(
        find.descendant(
          of: find.byType(EnableNotificationsInSettingsDialog),
          matching: find.byType(TextButton),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(EnableNotificationsInSettingsDialog), findsNothing);
      verifyNever(() => notificationService.openSystemSettings());
    });

    testWidgets('opens system settings on the confirm action', (tester) async {
      await showDialogUnderTest(tester);

      await tester.tap(
        find.descendant(
          of: find.byType(EnableNotificationsInSettingsDialog),
          matching: find.byType(FilledButton),
        ),
      );
      await tester.pumpAndSettle();

      verify(() => notificationService.openSystemSettings()).called(1);
    });
  });
}
