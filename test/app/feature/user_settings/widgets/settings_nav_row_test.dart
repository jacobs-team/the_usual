import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(SettingsNavRow, () {
    testWidgets('renders the title and subtitle', (tester) async {
      await tester.pumpPumpPumpItUP(
        SettingsNavRow(
          title: 'Your usual meals',
          subtitle: '3 items',
          onTap: () {},
        ),
      );

      expect(find.text('Your usual meals'), findsOneWidget);
      expect(find.text('3 items'), findsOneWidget);
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
