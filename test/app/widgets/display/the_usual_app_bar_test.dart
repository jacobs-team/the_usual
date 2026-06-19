import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(TheUsualAppBar, () {
    testWidgets('renders the string title when no title widget is given', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        const Scaffold(appBar: TheUsualAppBar(title: 'History')),
      );

      expect(find.text('History'), findsOneWidget);
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
      expect(find.text('Today'), findsNothing);
    });
  });
}
