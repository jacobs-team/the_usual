import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(ConfirmDialog, () {
    Future<bool?> showDialog(WidgetTester tester) async {
      bool? result;
      await tester.pumpPumpPumpItUP(
        Builder(
          builder: (context) => ElevatedButton(
            key: const Key('open-dialog'),
            onPressed: () async {
              result = await ConfirmDialog.show(
                context,
                title: 'Delete this?',
                message: 'This cannot be undone.',
                confirmLabel: 'Delete',
                isDestructive: true,
              );
            },
            child: const Text('Open'),
          ),
        ),
      );
      await tester.tap(find.byKey(const Key('open-dialog')));
      await tester.pumpAndSettle();
      return result;
    }

    testWidgets(
      'tapping the confirm button pops the dialog with true',
      (tester) async {
        await showDialog(tester);

        expect(find.byType(ConfirmDialog), findsOneWidget);

        await tester.tap(
          find.byKey(const Key('confirm-dialog-confirm')),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ConfirmDialog), findsNothing);
      },
    );

    testWidgets(
      'tapping Cancel pops the dialog without confirming',
      (tester) async {
        await showDialog(tester);

        expect(find.byType(ConfirmDialog), findsOneWidget);

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(find.byType(ConfirmDialog), findsNothing);
      },
    );
  });
}
