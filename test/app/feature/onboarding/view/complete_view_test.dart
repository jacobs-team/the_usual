import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(CompleteView, () {
    late OnboardingBloc onboardingBloc;

    setUp(() {
      onboardingBloc = MockOnboardingBloc();
      when(() => onboardingBloc.state).thenReturn(const OnboardingState());
      when(
        () => onboardingBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
    });

    GoRouter buildRouter() {
      return GoRouter(
        initialLocation: '/complete',
        routes: [
          GoRoute(
            path: '/complete',
            builder: (_, _) => const CompleteView(),
          ),
          GoRoute(
            path: Routes.today,
            builder: (_, _) => const Text('today-page'),
          ),
          GoRoute(
            path: Routes.settings,
            builder: (_, _) => const Text('settings-page'),
          ),
        ],
      );
    }

    testWidgets('renders the completion message', (tester) async {
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const SizedBox.shrink(),
        router: buildRouter(),
      );

      expect(find.text("You're all set."), findsOneWidget);
    });

    testWidgets('adds resetPressed when Reset app state is tapped', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const SizedBox.shrink(),
        router: buildRouter(),
      );

      await tester.tap(find.text('Reset app state'));

      verify(
        () => onboardingBloc.add(const OnboardingEvent.resetPressed()),
      ).called(1);
    });

    testWidgets('navigates to today when Done is tapped', (tester) async {
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const SizedBox.shrink(),
        router: buildRouter(),
      );

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(find.text('today-page'), findsOneWidget);
    });

    testWidgets('navigates to settings when Adjust settings is tapped', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const SizedBox.shrink(),
        router: buildRouter(),
      );

      await tester.tap(find.text('Adjust settings'));
      await tester.pumpAndSettle();

      expect(find.text('settings-page'), findsOneWidget);
    });
  });
}
