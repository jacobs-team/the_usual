import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(WelcomeView, () {
    late MockAuthCubit authCubit;
    late MockOnboardingBloc onboardingBloc;

    const signedInState = AuthState(
      status: AuthStatus.signedIn,
      user: AuthUser(id: 'u1', email: 'a@b.com'),
    );

    setUp(() {
      authCubit = MockAuthCubit();
      when(() => authCubit.state).thenReturn(const AuthState());
      when(() => authCubit.stream).thenAnswer((_) => const Stream.empty());
      onboardingBloc = MockOnboardingBloc();
      when(() => onboardingBloc.state).thenReturn(const OnboardingState());
      when(
        () => onboardingBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
    });

    testWidgets('a guest sees the sign-in and keep-offline choices', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        deps: [authCubit, onboardingBloc],
        const WelcomeView(),
      );

      expect(find.byType(GoogleSignInButton), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('keep it offline records a guest and continues onboarding', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        deps: [authCubit, onboardingBloc],
        const WelcomeView(),
      );

      await tester.tap(find.byType(OutlinedButton));

      verify(() => authCubit.continueAsGuest()).called(1);
      verify(
        () => onboardingBloc.add(const OnboardingEvent.continuePressed()),
      ).called(1);
    });

    testWidgets('a signed-in user sees Get started, which continues', (
      tester,
    ) async {
      when(() => authCubit.state).thenReturn(signedInState);

      await tester.pumpPumpPumpItUP(
        deps: [authCubit, onboardingBloc],
        const WelcomeView(),
      );

      expect(find.byType(GoogleSignInButton), findsNothing);
      await tester.tap(find.byType(FilledButton));

      verify(
        () => onboardingBloc.add(const OnboardingEvent.continuePressed()),
      ).called(1);
    });

    testWidgets('a successful sign-in advances onboarding when incomplete', (
      tester,
    ) async {
      when(() => authCubit.signInWithGoogle()).thenAnswer((_) async {
        when(() => authCubit.state).thenReturn(signedInState);
      });

      await tester.pumpPumpPumpItUP(
        deps: [authCubit, onboardingBloc],
        const WelcomeView(),
      );
      await tester.tap(find.byType(GoogleSignInButton));
      await tester.pump();

      verify(
        () => onboardingBloc.add(const OnboardingEvent.continuePressed()),
      ).called(1);
    });

    testWidgets(
      'signing into an existing, completed account does not advance',
      (
        tester,
      ) async {
        when(
          () => onboardingBloc.state,
        ).thenReturn(const OnboardingState(step: OnboardingStep.complete));
        when(() => authCubit.signInWithGoogle()).thenAnswer((_) async {
          when(() => authCubit.state).thenReturn(signedInState);
        });

        await tester.pumpPumpPumpItUP(
          deps: [authCubit, onboardingBloc],
          const WelcomeView(),
        );
        await tester.tap(find.byType(GoogleSignInButton));
        await tester.pump();

        verifyNever(
          () => onboardingBloc.add(const OnboardingEvent.continuePressed()),
        );
      },
    );

    testWidgets('a cancelled sign-in stays on welcome without advancing', (
      tester,
    ) async {
      when(() => authCubit.signInWithGoogle()).thenAnswer((_) async {});

      await tester.pumpPumpPumpItUP(
        deps: [authCubit, onboardingBloc],
        const WelcomeView(),
      );
      await tester.tap(find.byType(GoogleSignInButton));
      await tester.pump();

      verifyNever(
        () => onboardingBloc.add(const OnboardingEvent.continuePressed()),
      );
    });
  });
}
