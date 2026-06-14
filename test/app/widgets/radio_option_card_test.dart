import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(RadioOptionCard, () {
    testWidgets('renders title, subtitle, and an optional note', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        RadioOptionCard(
          title: 'Notifications',
          subtitle: 'A quick nudge',
          note: 'Asks permission',
          selected: true,
          onTap: () {},
        ),
      );

      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('A quick nudge'), findsOneWidget);
      expect(find.text('Asks permission'), findsOneWidget);
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

      expect(find.text('No reminders'), findsOneWidget);
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

      await tester.tap(find.text('Tap me'));

      expect(tapped, isTrue);
    });
  });
}
