import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(RadioOptionCard, () {
    testWidgets('renders the note when one is given', (tester) async {
      await tester.pumpPumpPumpItUP(
        RadioOptionCard(
          title: 'Notifications',
          subtitle: 'A quick nudge',
          note: 'Asks permission',
          selected: true,
          onTap: () {},
        ),
      );

      // Title, subtitle, and note each render as their own Text.
      expect(find.byType(Text), findsNWidgets(3));
    });

    testWidgets('omits the note when none is given', (tester) async {
      await tester.pumpPumpPumpItUP(
        RadioOptionCard(
          title: 'None',
          subtitle: 'No reminders',
          selected: false,
          onTap: () {},
        ),
      );

      // Only the title and subtitle render; the note Text is absent.
      expect(find.byType(Text), findsNWidgets(2));
    });

    testWidgets('shows the checked indicator when selected', (tester) async {
      await tester.pumpPumpPumpItUP(
        RadioOptionCard(
          title: 'Notifications',
          subtitle: 'A quick nudge',
          selected: true,
          onTap: () {},
        ),
      );

      expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpPumpPumpItUP(
        RadioOptionCard(
          title: 'Tap me',
          subtitle: 'subtitle',
          selected: false,
          onTap: () => tapped = true,
        ),
      );

      await tester.tap(find.byType(RadioOptionCard));

      expect(tapped, isTrue);
    });
  });
}
