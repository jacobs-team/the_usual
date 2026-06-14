import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(ThemeModeSelector, () {
    testWidgets('renders a segment for every theme mode', (tester) async {
      await tester.pumpPumpPumpItUP(
        ThemeModeSelector(themeMode: ThemeMode.system, onChanged: (_) {}),
      );

      expect(find.text('System'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
    });

    testWidgets('reports the chosen mode when a segment is tapped', (
      tester,
    ) async {
      ThemeMode? selected;
      await tester.pumpPumpPumpItUP(
        ThemeModeSelector(
          themeMode: ThemeMode.system,
          onChanged: (mode) => selected = mode,
        ),
      );

      await tester.tap(find.text('Dark'));

      expect(selected, equals(ThemeMode.dark));
    });
  });
}
