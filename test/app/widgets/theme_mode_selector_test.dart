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

      final segmentedButton = tester.widget<SegmentedButton<ThemeMode>>(
        find.byType(SegmentedButton<ThemeMode>),
      );
      expect(segmentedButton.segments, hasLength(ThemeMode.values.length));
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

      // Each segment renders as a TextButton in ThemeMode.values order.
      final darkSegment = find
          .byType(TextButton)
          .at(ThemeMode.values.indexOf(ThemeMode.dark));
      await tester.tap(darkSegment);

      expect(selected, equals(ThemeMode.dark));
    });
  });
}
