import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(VolumeBar, () {
    testWidgets('renders', (tester) async {
      await tester.pumpPumpPumpItUP(
        const VolumeBar(volume: 1500, weightUnit: WeightUnit.kg),
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
