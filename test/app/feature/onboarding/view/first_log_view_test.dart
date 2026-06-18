import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(FirstLogView, () {
    late OnboardingBloc onboardingBloc;

    // Seed every meal with the same usual so the grid is populated whatever
    // meal the current time resolves to.
    Map<MealOfTheDay, List<UsualMeal>> usualsForEveryMeal() {
      return {
        for (final mealOfTheDay in MealOfTheDay.values)
          mealOfTheDay: const [UsualMeal(id: 'a', name: 'Pancakes')],
      };
    }

    void stubBloc(OnboardingState state) {
      when(() => onboardingBloc.state).thenReturn(state);
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

    testWidgets('shows an empty state when there are no usuals', (
      tester,
    ) async {
      useTallWindow(tester);
      stubBloc(const OnboardingState(step: OnboardingStep.firstLog));
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const FirstLogView(),
      );

      expect(find.textContaining('usual meals yet'), findsOneWidget);
    });

    testWidgets('a usual with no photo shows no image placeholder', (
      tester,
    ) async {
      useTallWindow(tester);
      stubBloc(
        OnboardingState(
          step: OnboardingStep.firstLog,
          settings: UserSettingsState(usuals: usualsForEveryMeal()),
        ),
      );
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const FirstLogView(),
      );

      expect(find.byIcon(Icons.image_outlined), findsNothing);
    });

    testWidgets('toggles a food card', (tester) async {
      useTallWindow(tester);
      stubBloc(
        OnboardingState(
          step: OnboardingStep.firstLog,
          settings: UserSettingsState(usuals: usualsForEveryMeal()),
        ),
      );
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const FirstLogView(),
      );

      await tester.tap(find.text('Pancakes').first);

      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.firstLogItemToggled('a'),
        ),
      ).called(1);
    });

    testWidgets('stepping a selected card adds firstLogItemQuantityChanged', (
      tester,
    ) async {
      useTallWindow(tester);
      registerFallbackValue(
        const OnboardingEvent.firstLogItemQuantityChanged('a', 1),
      );
      stubBloc(
        OnboardingState(
          step: OnboardingStep.firstLog,
          firstLogSelectedIds: const ['a'],
          settings: UserSettingsState(usuals: usualsForEveryMeal()),
        ),
      );
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const FirstLogView(),
      );

      await tester.tap(find.byIcon(Icons.add).first);

      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.firstLogItemQuantityChanged('a', 2),
        ),
      ).called(1);
    });

    testWidgets('Log it is disabled until something is selected', (
      tester,
    ) async {
      useTallWindow(tester);
      stubBloc(
        OnboardingState(
          step: OnboardingStep.firstLog,
          settings: UserSettingsState(usuals: usualsForEveryMeal()),
        ),
      );
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const FirstLogView(),
      );

      final logIt = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Log it'),
      );
      expect(logIt.onPressed, isNull);
    });

    testWidgets('Log it continues when something is selected', (tester) async {
      useTallWindow(tester);
      stubBloc(
        OnboardingState(
          step: OnboardingStep.firstLog,
          firstLogSelectedIds: const ['a'],
          settings: UserSettingsState(usuals: usualsForEveryMeal()),
        ),
      );
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const FirstLogView(),
      );

      await tester.tap(find.text('Log it'));

      verify(
        () => onboardingBloc.add(const OnboardingEvent.continuePressed()),
      ).called(1);
    });

    testWidgets('the skip-meal action continues', (tester) async {
      useTallWindow(tester);
      stubBloc(
        OnboardingState(
          step: OnboardingStep.firstLog,
          settings: UserSettingsState(usuals: usualsForEveryMeal()),
        ),
      );
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const FirstLogView(),
      );

      await tester.tap(find.textContaining("I didn't eat"));

      verify(
        () => onboardingBloc.add(const OnboardingEvent.continuePressed()),
      ).called(1);
    });

    testWidgets('logging something else adds a somethingElseLogged event', (
      tester,
    ) async {
      useTallWindow(tester);
      stubBloc(
        OnboardingState(
          step: OnboardingStep.firstLog,
          settings: UserSettingsState(usuals: usualsForEveryMeal()),
        ),
      );
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const FirstLogView(),
      );

      await tester.tap(find.text('I ate something else'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, 'Burrito');
      await tester.pump();
      await tester.tap(find.text('Log'));
      await tester.pumpAndSettle();

      final captured = verify(
        () => onboardingBloc.add(captureAny()),
      ).captured;
      final logged = captured.whereType<SomethingElseLogged>().single;
      expect(logged.name, equals('Burrito'));
    });

    testWidgets('cancelling the something-else sheet adds nothing', (
      tester,
    ) async {
      useTallWindow(tester);
      stubBloc(
        OnboardingState(
          step: OnboardingStep.firstLog,
          settings: UserSettingsState(usuals: usualsForEveryMeal()),
        ),
      );
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const FirstLogView(),
      );

      await tester.tap(find.text('I ate something else'));
      await tester.pumpAndSettle();
      // A fresh sheet has one row, so the only close icon is the sheet's.
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      verifyNever(
        () => onboardingBloc.add(any(that: isA<SomethingElseLogged>())),
      );
    });

    testWidgets('shows a photo on a usual that has one', (tester) async {
      // Pinned to breakfast so the seeded breakfast usual is the meal shown.
      await withTestClock(() async {
        final dir = Directory.systemTemp.createTempSync('first_log_photo');
        addTearDown(() => dir.deleteSync(recursive: true));
        final photo = File('${dir.path}/meal.png')
          ..writeAsBytesSync(transparentPixel);

        useTallWindow(tester);
        stubBloc(
          OnboardingState(
            step: OnboardingStep.firstLog,
            settings: UserSettingsState(
              usuals: {
                MealOfTheDay.breakfast: [
                  UsualMeal(id: 'a', name: 'Pancakes', photoPath: photo.path),
                ],
              },
            ),
          ),
        );
        await tester.pumpPumpPumpItUP(
          deps: [onboardingBloc],
          const FirstLogView(),
        );
        await tester.pump();

        expect(find.byType(Image), findsWidgets);
      });
    });
  });
}
