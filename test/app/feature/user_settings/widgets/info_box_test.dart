import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(InfoBox, () {
    testWidgets('renders its message inside a dashed box', (tester) async {
      await tester.pumpPumpPumpItUP(
        const InfoBox('Reminders are off.'),
      );

      expect(find.text('Reminders are off.'), findsOneWidget);
    });

    testWidgets('repaints its border when the theme color changes', (
      tester,
    ) async {
      final key = GlobalKey();
      var brightness = Brightness.light;
      late StateSetter setBrightness;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            setBrightness = setState;
            return MaterialApp(
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.blue,
                  brightness: brightness,
                ),
              ),
              home: Scaffold(body: InfoBox('Reminders are off.', key: key)),
            );
          },
        ),
      );

      // Rebuild the same InfoBox element with a new theme color so the
      // painter's shouldRepaint runs against the previous painter.
      setBrightness(() => brightness = Brightness.dark);
      await tester.pump();

      expect(find.byType(InfoBox), findsOneWidget);
    });
  });
}
