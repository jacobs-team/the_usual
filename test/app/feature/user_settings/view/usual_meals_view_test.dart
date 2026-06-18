import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(UsualMealsView, () {
    GoRouter buildRouter() {
      return GoRouter(
        initialLocation: Routes.usualMeals,
        routes: [
          GoRoute(
            path: Routes.usualMeals,
            builder: (_, _) => const UsualMealsView(),
          ),
          GoRoute(
            path: Routes.settings,
            builder: (_, _) => const Text('settings-page'),
          ),
        ],
      );
    }

    Future<void> pumpView(WidgetTester tester) {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      return tester.pumpPumpPumpItUP(
        const SizedBox.shrink(),
        router: buildRouter(),
      );
    }

    testWidgets('renders a tab per meal', (tester) async {
      await pumpView(tester);

      expect(find.byType(Tab), findsNWidgets(MealOfTheDay.values.length));
      expect(find.text('Your usual meals'), findsOneWidget);
      expect(find.byType(UsualMealList), findsWidgets);
    });

    testWidgets('the back button returns to settings', (tester) async {
      await pumpView(tester);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.text('settings-page'), findsOneWidget);
    });

    testWidgets('the add button logs a new usual to the active meal', (
      tester,
    ) async {
      final userSettingsBloc = MockUserSettingsBloc();
      when(() => userSettingsBloc.state).thenReturn(const UserSettingsState());
      when(
        () => userSettingsBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
      final mealAiRepository = MockMealAiRepository();
      when(() => mealAiRepository.isConfigured).thenReturn(false);

      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpPumpPumpItUP(
        const SizedBox.shrink(),
        router: buildRouter(),
        deps: [userSettingsBloc, mealAiRepository],
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(
        find
            .descendant(
              of: find.byType(FoodEntrySheet),
              matching: find.byType(TextFormField),
            )
            .first,
        'Oats',
      );
      await tester.pump();
      await tester.tap(
        find.descendant(
          of: find.byType(FoodEntrySheet),
          matching: find.byType(FilledButton),
        ),
      );
      await tester.pumpAndSettle();

      // The first tab is breakfast, so the new usual lands there.
      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.usualMealAdded(
            MealOfTheDay.breakfast,
            'Oats',
            Nutrition(),
          ),
        ),
      ).called(1);
    });
  });
}
