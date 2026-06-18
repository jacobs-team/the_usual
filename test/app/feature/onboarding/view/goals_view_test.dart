import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(GoalsView, () {
    late OnboardingBloc onboardingBloc;

    void stubBloc(UserSettingsState settings) {
      when(() => onboardingBloc.state).thenReturn(
        OnboardingState(step: OnboardingStep.goals, settings: settings),
      );
      when(
        () => onboardingBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
    }

    setUp(() {
      onboardingBloc = MockOnboardingBloc();
      registerFallbackValue(const OnboardingEvent.continuePressed());
    });

    void useTallWindow(WidgetTester tester) {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    testWidgets('adds calorieGoalChanged from the calorie field', (
      tester,
    ) async {
      useTallWindow(tester);
      stubBloc(const UserSettingsState());
      await tester.pumpPumpPumpItUP(deps: [onboardingBloc], const GoalsView());

      await tester.enterText(
        find.descendant(
          of: find.byType(MacroField),
          matching: find.byType(TextFormField),
        ),
        '2200',
      );

      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.calorieGoalChanged(2200),
        ),
      ).called(1);
    });

    testWidgets('adds weightGoalChanged from the weight field', (
      tester,
    ) async {
      useTallWindow(tester);
      stubBloc(const UserSettingsState());
      await tester.pumpPumpPumpItUP(deps: [onboardingBloc], const GoalsView());

      await tester.enterText(
        find.descendant(
          of: find.byType(WeightInput),
          matching: find.byType(TextFormField),
        ),
        '150.5',
      );

      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.weightGoalChanged(150.5),
        ),
      ).called(1);
    });

    testWidgets('adds weightUnitSelected from the unit chips', (tester) async {
      useTallWindow(tester);
      stubBloc(const UserSettingsState());
      await tester.pumpPumpPumpItUP(deps: [onboardingBloc], const GoalsView());

      await tester.tap(
        find.descendant(
          of: find.byType(WeightInput),
          matching: find.text(WeightUnit.kg.name),
        ),
      );

      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.weightUnitSelected(WeightUnit.kg),
        ),
      ).called(1);
    });

    testWidgets('adds continuePressed from the actions', (tester) async {
      useTallWindow(tester);
      stubBloc(const UserSettingsState());
      await tester.pumpPumpPumpItUP(deps: [onboardingBloc], const GoalsView());

      await tester.tap(find.text('Continue'));

      verify(
        () => onboardingBloc.add(const OnboardingEvent.continuePressed()),
      ).called(1);
    });
  });
}
