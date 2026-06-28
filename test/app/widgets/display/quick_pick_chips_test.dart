import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(ExpandableChipWrap, () {
    QuickPickChipData chip(String label) {
      return QuickPickChipData(
        label: label,
        onPressed: () {},
        onRemove: () {},
      );
    }

    Future<void> pumpWrap(
      WidgetTester tester, {
      required List<QuickPickChipData> chips,
      int maxCollapsedRows = 3,
    }) {
      // A moderate width so several chips share a row before the rest spill
      // past the collapsed row budget, surfacing the overflow toggle.
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      return tester.pumpPumpPumpItUP(
        ExpandableChipWrap(chips: chips, maxCollapsedRows: maxCollapsedRows),
      );
    }

    // Short labels so several share a row before overflowing to the next.
    List<QuickPickChipData> manyChips() => [
      for (var i = 0; i < 8; i++) chip('+ A$i'),
    ];

    testWidgets('hides the overflow toggle when every chip fits', (
      tester,
    ) async {
      await pumpWrap(tester, chips: [chip('+ Eggs')]);

      expect(find.byType(TextButton), findsNothing);
      expect(find.byType(QuickPickChip), findsOneWidget);
    });

    testWidgets('shows an overflow toggle when chips exceed the row budget', (
      tester,
    ) async {
      await pumpWrap(tester, chips: manyChips(), maxCollapsedRows: 1);

      expect(find.byType(TextButton), findsOneWidget);
      expect(find.byIcon(Icons.expand_more), findsOneWidget);
      // Collapsed, so not every chip is rendered.
      expect(
        tester.widgetList<QuickPickChip>(find.byType(QuickPickChip)).length,
        lessThan(8),
      );
    });

    testWidgets('reveals the hidden chips when expanded then collapses again', (
      tester,
    ) async {
      await pumpWrap(tester, chips: manyChips(), maxCollapsedRows: 1);

      final collapsedCount = tester
          .widgetList<QuickPickChip>(find.byType(QuickPickChip))
          .length;

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.expand_less), findsOneWidget);
      expect(find.byType(QuickPickChip), findsNWidgets(8));

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.expand_more), findsOneWidget);
      expect(
        tester.widgetList<QuickPickChip>(find.byType(QuickPickChip)).length,
        equals(collapsedCount),
      );
    });
  });
}
