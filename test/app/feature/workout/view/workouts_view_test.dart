import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(WorkoutsView, () {
    testWidgets('renders the shared app bar', (tester) async {
      await tester.pumpPumpPumpItUP(const WorkoutsView());

      expect(find.byType(TheUsualAppBar), findsOneWidget);
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.title, isA<Text>());
    });
  });
}
