import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(BuildUsualsView, () {
    OnboardingBloc blocWith(OnboardingState state) {
      final onboardingBloc = MockOnboardingBloc();
      when(() => onboardingBloc.state).thenReturn(state);
      when(
        () => onboardingBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
      return onboardingBloc;
    }

    setUp(() {
      registerFallbackValue(const OnboardingEvent.continuePressed());
    });

    testWidgets('renders a section per meal', (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpPumpPumpItUP(
        deps: [blocWith(const OnboardingState())],
        const BuildUsualsView(),
      );

      expect(find.byType(UsualMealSection), findsNWidgets(4));
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('adds continuePressed and skipPressed from the actions', (
      tester,
    ) async {
      final onboardingBloc = blocWith(const OnboardingState());
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const BuildUsualsView(),
      );

      await tester.tap(find.text('Continue'));
      await tester.tap(find.text('Skip for now'));

      verify(
        () => onboardingBloc.add(const OnboardingEvent.continuePressed()),
      ).called(1);
      verify(
        () => onboardingBloc.add(const OnboardingEvent.skipPressed()),
      ).called(1);
    });

    testWidgets('adds usualMealAdded from the first composer', (tester) async {
      final onboardingBloc = blocWith(const OnboardingState());
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const BuildUsualsView(),
      );

      final firstComposerName = find
          .descendant(
            of: find.byType(UsualMealComposer).first,
            matching: find.byType(TextFormField),
          )
          .first;
      await tester.enterText(firstComposerName, 'Eggs');
      await tester.tap(find.byIcon(Icons.add).first);

      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.usualMealAdded(
            MealOfTheDay.breakfast,
            'Eggs',
            Nutrition(),
          ),
        ),
      ).called(1);
    });

    testWidgets('edits and removes a saved usual meal', (tester) async {
      final onboardingBloc = blocWith(
        const OnboardingState(
          settings: UserSettingsState(
            expandNutritionByDefault: true,
            usuals: {
              MealOfTheDay.breakfast: [UsualMeal(id: 'a', name: 'Eggs')],
            },
          ),
        ),
      );
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const BuildUsualsView(),
      );

      final rowCalories = find
          .descendant(
            of: find.byType(ExpandableNutrition),
            matching: find.byType(TextFormField),
          )
          .first;
      await tester.enterText(rowCalories, '275');
      await tester.tap(find.byIcon(Icons.remove).first);

      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.usualMealNutritionChanged(
            MealOfTheDay.breakfast,
            'a',
            Nutrition(calories: 275),
          ),
        ),
      ).called(1);
      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.usualMealRemoved(MealOfTheDay.breakfast, 'a'),
        ),
      ).called(1);
    });
  });
}
