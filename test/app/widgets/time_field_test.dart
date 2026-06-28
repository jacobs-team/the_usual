import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(TimeField, () {
    EditableText editableFor(WidgetTester tester, Key key) {
      return tester.widget<EditableText>(
        find.descendant(
          of: find.byKey(key),
          matching: find.byType(EditableText),
        ),
      );
    }

    testWidgets('leaves both fields empty for a zero duration', (tester) async {
      await tester.pumpPumpPumpItUP(
        TimeField(initial: Duration.zero, onChanged: (_) {}),
      );

      expect(
        editableFor(tester, const Key('cardio-minutes')).controller.text,
        isEmpty,
      );
      expect(
        editableFor(tester, const Key('cardio-seconds')).controller.text,
        isEmpty,
      );
    });

    testWidgets('seeds the fields from a non-zero duration', (tester) async {
      await tester.pumpPumpPumpItUP(
        TimeField(
          initial: const Duration(minutes: 2, seconds: 15),
          onChanged: (_) {},
        ),
      );

      expect(
        editableFor(tester, const Key('cardio-minutes')).controller.text,
        equals('2'),
      );
      expect(
        editableFor(tester, const Key('cardio-seconds')).controller.text,
        equals('15'),
      );
    });

    testWidgets('reports the combined duration when the minutes change', (
      tester,
    ) async {
      Duration? changed;
      await tester.pumpPumpPumpItUP(
        TimeField(
          initial: const Duration(seconds: 30),
          onChanged: (duration) => changed = duration,
        ),
      );

      await tester.enterText(find.byKey(const Key('cardio-minutes')), '3');

      expect(changed, equals(const Duration(minutes: 3, seconds: 30)));
    });

    testWidgets('reports the combined duration when the seconds change', (
      tester,
    ) async {
      Duration? changed;
      await tester.pumpPumpPumpItUP(
        TimeField(
          initial: const Duration(minutes: 1),
          onChanged: (duration) => changed = duration,
        ),
      );

      await tester.enterText(find.byKey(const Key('cardio-seconds')), '45');

      expect(changed, equals(const Duration(minutes: 1, seconds: 45)));
    });

    testWidgets('treats cleared fields as zero', (tester) async {
      Duration? changed;
      await tester.pumpPumpPumpItUP(
        TimeField(
          initial: const Duration(minutes: 5, seconds: 5),
          onChanged: (duration) => changed = duration,
        ),
      );

      await tester.enterText(find.byKey(const Key('cardio-minutes')), '');

      expect(changed, equals(const Duration(seconds: 5)));
    });
  });
}
