import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(FoodEntrySheet, () {
    /// Opens the sheet from a button and records whatever it pops with.
    Future<List<(String, int?, bool)?>> showSheet(
      WidgetTester tester, {
      bool showAddToUsualMeals = false,
    }) async {
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final results = <(String, int?, bool)?>[];
      await tester.pumpPumpPumpItUP(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              final result =
                  await showModalBottomSheet<(String, int?, bool)>(
                    context: context,
                    builder: (_) => FoodEntrySheet(
                      title: 'Log food',
                      confirmLabel: 'Log',
                      showAddToUsualMeals: showAddToUsualMeals,
                    ),
                  );
              results.add(result);
            },
            child: const Text('open'),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      return results;
    }

    testWidgets('renders title and sections', (tester) async {
      await showSheet(tester);

      expect(find.text('Log food'), findsOneWidget);
      expect(find.text('NAME'), findsOneWidget);
      expect(find.text('CALORIES · OPTIONAL'), findsOneWidget);
    });

    testWidgets('confirm is disabled until a name is entered', (tester) async {
      await showSheet(tester);

      final confirmBefore = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );
      expect(confirmBefore.onPressed, isNull);

      await tester.enterText(find.byType(TextFormField).first, 'Salad');
      await tester.pump();

      final confirmAfter = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );
      expect(confirmAfter.onPressed, isNotNull);
    });

    testWidgets('confirm pops with the entered values', (tester) async {
      final results = await showSheet(tester, showAddToUsualMeals: true);

      await tester.enterText(find.byType(TextFormField).first, 'Salad');
      await tester.enterText(find.byType(TextFormField).last, '380');
      await tester.pump();
      await tester.tap(find.text('Log'));
      await tester.pumpAndSettle();

      expect(results.single, equals(('Salad', 380, true)));
    });

    testWidgets('toggling the checkbox flips the add-to-usuals flag', (
      tester,
    ) async {
      final results = await showSheet(tester, showAddToUsualMeals: true);

      await tester.enterText(find.byType(TextFormField).first, 'Salad');
      await tester.pump();
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pump();
      await tester.tap(find.text('Log'));
      await tester.pumpAndSettle();

      expect(results.single, equals(('Salad', null, false)));
    });

    testWidgets('cancel pops with null', (tester) async {
      final results = await showSheet(tester);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(results.single, isNull);
    });
  });
}
