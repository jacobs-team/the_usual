import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(TheUsualAppBar, () {
    testWidgets('renders a Text title when no title widget is given', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        const Scaffold(appBar: TheUsualAppBar(title: 'History')),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.title, isA<Text>());
    });

    testWidgets('renders the title widget when provided', (tester) async {
      await tester.pumpPumpPumpItUP(
        const Scaffold(
          appBar: TheUsualAppBar(
            title: 'Today',
            titleWidget: Icon(Icons.calendar_today, key: Key('custom-title')),
          ),
        ),
      );

      expect(find.byKey(const Key('custom-title')), findsOneWidget);

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.title, isA<Icon>());
    });
  });
}
