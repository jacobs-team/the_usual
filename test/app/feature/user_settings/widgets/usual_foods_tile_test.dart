import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(UsualFoodsTile, () {
    late UserSettingsBloc userSettingsBloc;

    setUp(() {
      userSettingsBloc = MockUserSettingsBloc();
      when(() => userSettingsBloc.state).thenReturn(
        const UserSettingsState(
          usualFoods: [
            UsualFood(id: 'a', name: 'Chicken, 1 oz'),
            UsualFood(id: 'b', name: 'Oats, 1 cup'),
          ],
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
            builder: (_, _) => const UsualFoodsTile(),
          ),
          GoRoute(
            path: Routes.usualFoods,
            builder: (_, _) =>
                const SizedBox.shrink(key: Key('usual-foods-page')),
          ),
        ],
      );
    }

    testWidgets('shows the food count in the subtitle', (tester) async {
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const SizedBox.shrink(),
        router: buildRouter(),
      );

      final settingsNavRow = tester.widget<SettingsNavRow>(
        find.byType(SettingsNavRow),
      );
      expect(settingsNavRow.subtitle, contains('2'));
    });

    testWidgets('navigates to the usual foods screen when tapped', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const SizedBox.shrink(),
        router: buildRouter(),
      );

      await tester.tap(find.byType(SettingsNavRow));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('usual-foods-page')), findsOneWidget);
    });
  });
}
