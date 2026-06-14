import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
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
  });
}
