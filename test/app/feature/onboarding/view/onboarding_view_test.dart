import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(OnboardingView, () {
    OnboardingBloc blocAtStep(OnboardingStep step) {
      final onboardingBloc = MockOnboardingBloc();
      when(
        () => onboardingBloc.state,
      ).thenReturn(OnboardingState(step: step));
      when(
        () => onboardingBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
      return onboardingBloc;
    }

    Future<void> pumpAtStep(WidgetTester tester, OnboardingStep step) {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      return tester.pumpPumpPumpItUP(
        deps: [blocAtStep(step)],
        const OnboardingView(),
      );
    }

    testWidgets('renders the welcome screen', (tester) async {
      await pumpAtStep(tester, OnboardingStep.welcome);
      expect(find.byType(WelcomeView), findsOneWidget);
    });

    testWidgets('renders build usuals', (tester) async {
      await pumpAtStep(tester, OnboardingStep.buildUsuals);
      expect(find.byType(BuildUsualsView), findsOneWidget);
    });

    testWidgets('renders reminders', (tester) async {
      await pumpAtStep(tester, OnboardingStep.reminders);
      expect(find.byType(RemindersView), findsOneWidget);
    });

    testWidgets('renders weight tracking', (tester) async {
      await pumpAtStep(tester, OnboardingStep.weightTracking);
      expect(find.byType(WeightTrackingView), findsOneWidget);
    });

    testWidgets('renders goals', (tester) async {
      await pumpAtStep(tester, OnboardingStep.goals);
      expect(find.byType(GoalsView), findsOneWidget);
    });

    testWidgets('renders first log', (tester) async {
      await pumpAtStep(tester, OnboardingStep.firstLog);
      expect(find.byType(FirstLogView), findsOneWidget);
    });

    testWidgets('renders no onboarding screen at the completion step', (
      tester,
    ) async {
      // Completion has no screen of its own; the app routes to Today instead.
      await pumpAtStep(tester, OnboardingStep.complete);
      expect(find.byType(OnboardingScaffold), findsNothing);
    });
  });
}
