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
            builder: (_, _) =>
                const SizedBox.shrink(key: Key('usual-meals-page')),
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

      // One usual was seeded, so the subtitle reflects that count.
      final settingsNavRow = tester.widget<SettingsNavRow>(
        find.byType(SettingsNavRow),
      );
      expect(settingsNavRow.subtitle, contains('1'));
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

      expect(find.byKey(const Key('usual-meals-page')), findsOneWidget);
    });
  });
}
