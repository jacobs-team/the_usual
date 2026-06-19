import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(SettingsNavRow, () {
    testWidgets('renders a tappable row with a trailing chevron', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        SettingsNavRow(
          title: 'Your usual meals',
          subtitle: '3 items',
          onTap: () {},
        ),
      );

      expect(find.byType(ListTile), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('runs onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpPumpPumpItUP(
        SettingsNavRow(
          title: 'Your usual meals',
          subtitle: '3 items',
          onTap: () => tapped = true,
        ),
      );

      await tester.tap(find.byType(SettingsNavRow));

      expect(tapped, isTrue);
    });
  });
}
