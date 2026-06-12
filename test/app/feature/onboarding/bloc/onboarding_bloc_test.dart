import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/feature/feature.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(OnboardingBloc, () {
    setUp(initHydratedStorage);

    test('initial state starts at ${OnboardingStep.welcome}', () {
      expect(
        OnboardingBloc().state,
        isA<OnboardingState>().having(
          (s) => s.step,
          'step',
          equals(OnboardingStep.welcome),
        ),
      );
    });

    blocTest<OnboardingBloc, OnboardingState>(
      'emits ${OnboardingStep.buildUsuals} when $GetStartedPressed is added',
      build: OnboardingBloc.new,
      act: (bloc) => bloc.add(const OnboardingEvent.getStartedPressed()),
      expect: () => [
        isA<OnboardingState>().having(
          (s) => s.step,
          'step',
          equals(OnboardingStep.buildUsuals),
        ),
      ],
    );

    test('toJson and fromJson round-trip the step', () {
      final bloc = OnboardingBloc();
      const state = OnboardingState(step: OnboardingStep.reminderStyle);

      final restored = bloc.fromJson(bloc.toJson(state));

      expect(
        restored,
        isA<OnboardingState>().having(
          (s) => s.step,
          'step',
          equals(OnboardingStep.reminderStyle),
        ),
      );
    });
  });
}
