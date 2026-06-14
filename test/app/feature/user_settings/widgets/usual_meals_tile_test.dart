import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(UsualMealsTile, () {
    late UserSettingsBloc userSettingsBloc;

    setUp(() {
      userSettingsBloc = MockUserSettingsBloc();
      when(() => userSettingsBloc.state).thenReturn(
        const UserSettingsState(
          usuals: {
            MealOfTheDay.breakfast: [UsualMeal(id: 'a', name: 'Eggs')],
          },
        ),
      );
      when(
        () => userSettingsBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
    });

    GoRouter buildRouter() {
      return GoRouter(
        initialLocation: Routes.settings,
        routes: [
          GoRoute(
            path: Routes.settings,
            builder: (_, _) => const UsualMealsTile(),
          ),
          GoRoute(
            path: Routes.usualMeals,
            builder: (_, _) => const Text('usual-meals-page'),
          ),
        ],
      );
    }

    testWidgets('summarizes the usuals count', (tester) async {
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const SizedBox.shrink(),
        router: buildRouter(),
      );

      expect(find.textContaining('1 items'), findsOneWidget);
    });

    testWidgets('navigates to the usual meals screen when tapped', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const SizedBox.shrink(),
        router: buildRouter(),
      );

      await tester.tap(find.byType(SettingsNavRow));
      await tester.pumpAndSettle();

      expect(find.text('usual-meals-page'), findsOneWidget);
    });
  });
}
