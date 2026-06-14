import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(SectionLabel, () {
    testWidgets('renders its text', (tester) async {
      await tester.pumpPumpPumpItUP(const SectionLabel('Meals'));

      expect(find.text('Meals'), findsOneWidget);
    });
  });
}
