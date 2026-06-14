import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(OnboardingView, () {
    OnboardingBloc blocAtStep(int activeStepIndex) {
      final onboardingBloc = MockOnboardingBloc();
      when(
        () => onboardingBloc.state,
      ).thenReturn(OnboardingState(activeStepIndex: activeStepIndex));
      when(
        () => onboardingBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
      return onboardingBloc;
    }

    Future<void> pumpAtStep(WidgetTester tester, int activeStepIndex) {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      return tester.pumpPumpPumpItUP(
        deps: [blocAtStep(activeStepIndex)],
        const OnboardingView(),
      );
    }

    testWidgets('renders the welcome screen on the first step', (tester) async {
      await pumpAtStep(tester, 0);
      expect(find.byType(WelcomeView), findsOneWidget);
    });

    testWidgets('renders build usuals on the second step', (tester) async {
      await pumpAtStep(tester, 1);
      expect(find.byType(BuildUsualsView), findsOneWidget);
    });

    testWidgets('renders reminder style on the third step', (tester) async {
      await pumpAtStep(tester, 2);
      expect(find.byType(ReminderStyleView), findsOneWidget);
    });

    testWidgets('renders meal schedule on the fourth step', (tester) async {
      await pumpAtStep(tester, 3);
      expect(find.byType(MealScheduleView), findsOneWidget);
    });

    testWidgets('renders weight tracking on the fifth step', (tester) async {
      await pumpAtStep(tester, 4);
      expect(find.byType(WeightTrackingView), findsOneWidget);
    });

    testWidgets('renders first log on the sixth step', (tester) async {
      await pumpAtStep(tester, 5);
      expect(find.byType(FirstLogView), findsOneWidget);
    });

    testWidgets('renders the completion screen on the last step', (
      tester,
    ) async {
      await pumpAtStep(tester, 6);
      expect(find.byType(CompleteView), findsOneWidget);
    });
  });
}
