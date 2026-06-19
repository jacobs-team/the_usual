import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(SectionLabel, () {
    testWidgets('renders the given text as a Text', (tester) async {
      const labelText = 'Meals';
      await tester.pumpPumpPumpItUP(const SectionLabel(labelText));

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.data, equals(labelText));
    });
  });
}
