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

    Future<void> pumpView(WidgetTester tester, OnboardingBloc bloc) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpPumpPumpItUP(deps: [bloc], const BuildUsualsView());
    }

    Finder continueButton() => find.descendant(
      of: find.byType(OnboardingActions),
      matching: find.byType(FilledButton),
    );

    Finder skipButton() => find.descendant(
      of: find.byType(OnboardingActions),
      matching: find.byType(TextButton),
    );

    testWidgets('shows a meal toggle and one form per meal', (tester) async {
      await pumpView(tester, blocWith(const OnboardingState()));

      expect(find.byType(SegmentedButton<MealOfTheDay>), findsOneWidget);
      // The IndexedStack builds a form for every meal; non-selected ones are
      // offstage, so don't skip them.
      expect(
        find.byType(FoodEntryForm, skipOffstage: false),
        findsNWidgets(MealOfTheDay.values.length),
      );
      expect(continueButton(), findsOneWidget);
    });

    testWidgets('selecting a meal switches the active form', (tester) async {
      await pumpView(tester, blocWith(const OnboardingState()));

      final stack = find.byType(IndexedStack);
      expect(tester.widget<IndexedStack>(stack).index, equals(0));

      const lunchIndex = 1;
      await tester.tap(
        find
            .descendant(
              of: find.byType(SegmentedButton<MealOfTheDay>),
              matching: find.byType(Text),
            )
            .at(lunchIndex),
      );
      await tester.pumpAndSettle();

      expect(
        tester.widget<IndexedStack>(stack).index,
        equals(MealOfTheDay.values.indexOf(MealOfTheDay.lunch)),
      );
    });

    testWidgets('Continue commits every meal then advances', (tester) async {
      final onboardingBloc = blocWith(const OnboardingState());
      await pumpView(tester, onboardingBloc);

      await tester.tap(continueButton());
      await tester.pump();

      for (final mealOfTheDay in MealOfTheDay.values) {
        verify(
          () => onboardingBloc.add(
            OnboardingEvent.usualsForMealReplaced(mealOfTheDay, const []),
          ),
        ).called(1);
      }
      verify(
        () => onboardingBloc.add(const OnboardingEvent.continuePressed()),
      ).called(1);
    });

    testWidgets('Skip commits every meal then skips', (tester) async {
      final onboardingBloc = blocWith(const OnboardingState());
      await pumpView(tester, onboardingBloc);

      await tester.tap(skipButton());
      await tester.pump();

      for (final mealOfTheDay in MealOfTheDay.values) {
        verify(
          () => onboardingBloc.add(
            OnboardingEvent.usualsForMealReplaced(mealOfTheDay, const []),
          ),
        ).called(1);
      }
      verify(
        () => onboardingBloc.add(const OnboardingEvent.skipPressed()),
      ).called(1);
    });

    testWidgets('seeds the selected meal from existing usuals and commits it', (
      tester,
    ) async {
      final onboardingBloc = blocWith(
        const OnboardingState(
          settings: UserSettingsState(
            usuals: {
              MealOfTheDay.breakfast: [UsualMeal(id: 'a', name: 'Eggs')],
            },
          ),
        ),
      );
      await pumpView(tester, onboardingBloc);

      // The breakfast form, selected first, seeds a row from the saved usual.
      final nameField = tester.widget<TextFormField>(
        find.byType(TextFormField).first,
      );
      expect(nameField.controller?.text, equals('Eggs'));

      await tester.tap(continueButton());
      await tester.pump();

      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.usualsForMealReplaced(MealOfTheDay.breakfast, [
            (name: 'Eggs', nutrition: Nutrition()),
          ]),
        ),
      ).called(1);
    });
  });
}
