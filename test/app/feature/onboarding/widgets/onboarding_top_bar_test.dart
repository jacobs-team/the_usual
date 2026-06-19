import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(OnboardingTopBar, () {
    late OnboardingBloc onboardingBloc;

    setUp(() {
      onboardingBloc = MockOnboardingBloc();
      when(() => onboardingBloc.state).thenReturn(const OnboardingState());
      when(
        () => onboardingBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
    });

    testWidgets('renders a progress dot per progress step', (tester) async {
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const Scaffold(
          appBar: OnboardingTopBar(step: OnboardingStep.buildUsuals),
        ),
      );

      expect(find.byType(OnboardingTopBar), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('hides skip when showSkip is false', (tester) async {
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const Scaffold(
          appBar: OnboardingTopBar(
            step: OnboardingStep.firstLog,
            showSkip: false,
          ),
        ),
      );

      expect(find.byType(TextButton), findsNothing);
    });

    testWidgets('adds backPressed when the back arrow is tapped', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const Scaffold(
          appBar: OnboardingTopBar(step: OnboardingStep.buildUsuals),
        ),
      );

      await tester.tap(find.byIcon(Icons.arrow_back));

      verify(
        () => onboardingBloc.add(const OnboardingEvent.backPressed()),
      ).called(1);
    });

    testWidgets('adds skipPressed when skip is tapped', (tester) async {
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const Scaffold(
          appBar: OnboardingTopBar(step: OnboardingStep.buildUsuals),
        ),
      );

      await tester.tap(find.byType(TextButton));

      verify(
        () => onboardingBloc.add(const OnboardingEvent.skipPressed()),
      ).called(1);
    });
  });
}
