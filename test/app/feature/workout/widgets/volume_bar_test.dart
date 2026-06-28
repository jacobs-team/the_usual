import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(VolumeBar, () {
    testWidgets('renders', (tester) async {
      // Built non-const so the constructor body is exercised for coverage.
      final volume = DateTime.now().microsecond.toDouble() + 1500;
      await tester.pumpPumpPumpItUP(
        VolumeBar(volume: volume, weightUnit: WeightUnit.kg),
      );

      expect(find.byType(VolumeBar), findsOneWidget);
    });

    testWidgets('shows a Text whose data contains the trimmed volume value', (
      tester,
    ) async {
      const volume = 1500.0;
      await tester.pumpPumpPumpItUP(
        const VolumeBar(volume: volume, weightUnit: WeightUnit.kg),
      );

      final texts = tester
          .widgetList<Text>(find.byType(Text))
          .where((text) => text.data?.contains(volume.trimmedDecimal) == true)
          .toList();

      expect(texts, isNotEmpty);
    });

    testWidgets(
      'shows a Text whose data contains the trimmed volume for decimal',
      (tester) async {
        const volume = 1500.5;
        await tester.pumpPumpPumpItUP(
          const VolumeBar(volume: volume, weightUnit: WeightUnit.kg),
        );

        final texts = tester
            .widgetList<Text>(find.byType(Text))
            .where((text) => text.data?.contains(volume.trimmedDecimal) == true)
            .toList();

        expect(texts, isNotEmpty);
      },
    );
  });
}
