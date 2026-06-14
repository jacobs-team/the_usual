import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(WelcomeView, () {
    late OnboardingBloc onboardingBloc;

    setUp(() {
      onboardingBloc = MockOnboardingBloc();
      when(() => onboardingBloc.state).thenReturn(const OnboardingState());
      when(
        () => onboardingBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
    });

    testWidgets('renders the value proposition', (tester) async {
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const WelcomeView(),
      );

      expect(find.text('The Usual'), findsOneWidget);
      expect(find.text('Get started'), findsOneWidget);
    });

    testWidgets('adds continuePressed when Get started is tapped', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const WelcomeView(),
      );

      await tester.tap(find.text('Get started'));

      verify(
        () => onboardingBloc.add(const OnboardingEvent.continuePressed()),
      ).called(1);
    });
  });
}
