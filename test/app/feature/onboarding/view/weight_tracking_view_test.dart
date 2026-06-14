import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(WeightTrackingView, () {
    late OnboardingBloc onboardingBloc;

    void stubBloc(UserSettingsState settings) {
      when(() => onboardingBloc.state).thenReturn(
        OnboardingState(activeStepIndex: 4, settings: settings),
      );
      when(
        () => onboardingBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
    }

    setUp(() {
      onboardingBloc = MockOnboardingBloc();
    });

    void useTallWindow(WidgetTester tester) {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    testWidgets('shows time and weight inputs when tracking is on', (
      tester,
    ) async {
      useTallWindow(tester);
      stubBloc(const UserSettingsState(startingWeight: 165));
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const WeightTrackingView(),
      );

      expect(find.byType(WeightCheckinFrequencyChips), findsOneWidget);
      expect(find.byType(WeightTimeOfDayChips), findsOneWidget);
      expect(find.byType(WeightInput), findsOneWidget);
    });

    testWidgets('hides time and weight inputs when tracking is off', (
      tester,
    ) async {
      useTallWindow(tester);
      stubBloc(
        const UserSettingsState(
          weightCheckinFrequency: WeightCheckinFrequency.off,
        ),
      );
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const WeightTrackingView(),
      );

      expect(find.byType(WeightTimeOfDayChips), findsNothing);
      expect(find.byType(WeightInput), findsNothing);
    });

    testWidgets('reports every weight setting change', (tester) async {
      useTallWindow(tester);
      stubBloc(const UserSettingsState());
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const WeightTrackingView(),
      );

      await tester.tap(find.text(WeightCheckinFrequency.weekly.label));
      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.weightCheckinFrequencySelected(
            WeightCheckinFrequency.weekly,
          ),
        ),
      ).called(1);

      await tester.tap(find.text(WeightTimeOfDay.night.label));
      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.weightTimeOfDaySelected(WeightTimeOfDay.night),
        ),
      ).called(1);

      await tester.enterText(find.byType(TextFormField), '180');
      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.startingWeightChanged(180),
        ),
      ).called(1);

      await tester.tap(find.text('kg'));
      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.weightUnitSelected(WeightUnit.kg),
        ),
      ).called(1);
    });

    testWidgets('adds continuePressed from the actions', (tester) async {
      useTallWindow(tester);
      stubBloc(const UserSettingsState());
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const WeightTrackingView(),
      );

      await tester.tap(find.text('Continue'));

      verify(
        () => onboardingBloc.add(const OnboardingEvent.continuePressed()),
      ).called(1);
    });
  });
}
