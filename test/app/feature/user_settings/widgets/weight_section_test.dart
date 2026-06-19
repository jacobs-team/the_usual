import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(WeightSection, () {
    late UserSettingsBloc userSettingsBloc;

    void stub(UserSettingsState state) {
      when(() => userSettingsBloc.state).thenReturn(state);
      when(
        () => userSettingsBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
    }

    setUp(() {
      userSettingsBloc = MockUserSettingsBloc();
    });

    void useTallWindow(WidgetTester tester) {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    testWidgets('shows an off notice when check-ins are off', (tester) async {
      stub(
        const UserSettingsState(
          weightCheckinFrequency: WeightCheckinFrequency.off,
        ),
      );
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const WeightSection(),
      );

      expect(find.byType(InfoBox), findsOneWidget);
      expect(find.byType(WeightInput), findsNothing);
    });

    testWidgets('shows time and weight inputs when on, prefilled', (
      tester,
    ) async {
      useTallWindow(tester);
      stub(const UserSettingsState(startingWeight: 165));
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const WeightSection(),
      );

      expect(find.byType(WeightTimeOfDayChips), findsOneWidget);
      expect(find.byType(WeightInput), findsOneWidget);
    });

    testWidgets('reports every weight setting change', (tester) async {
      useTallWindow(tester);
      stub(const UserSettingsState());
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const WeightSection(),
      );

      // Chips render in enum order inside their owning widget.
      final frequencyChip = find
          .descendant(
            of: find.byType(WeightCheckinFrequencyChips),
            matching: find.byType(ChoiceChip),
          )
          .at(
            WeightCheckinFrequency.values.indexOf(
              WeightCheckinFrequency.weekly,
            ),
          );
      await tester.tap(frequencyChip);
      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.weightCheckinFrequencySelected(
            WeightCheckinFrequency.weekly,
          ),
        ),
      ).called(1);

      final timeOfDayChip = find
          .descendant(
            of: find.byType(WeightTimeOfDayChips),
            matching: find.byType(ChoiceChip),
          )
          .at(WeightTimeOfDay.values.indexOf(WeightTimeOfDay.night));
      await tester.tap(timeOfDayChip);
      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.weightTimeOfDaySelected(
            WeightTimeOfDay.night,
          ),
        ),
      ).called(1);

      await tester.enterText(find.byType(TextFormField), '180');
      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.startingWeightChanged(180),
        ),
      ).called(1);

      final unitChip = find
          .descendant(
            of: find.byType(WeightInput),
            matching: find.byType(ChoiceChip),
          )
          .at(WeightUnit.values.indexOf(WeightUnit.kg));
      await tester.tap(unitChip);
      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.weightUnitSelected(WeightUnit.kg),
        ),
      ).called(1);
    });
  });
}
