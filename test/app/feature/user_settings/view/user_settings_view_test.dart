import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(UserSettingsView, () {
    GoRouter buildRouter({String initialLocation = Routes.settings}) {
      return GoRouter(
        initialLocation: initialLocation,
        routes: [
          GoRoute(
            path: Routes.settings,
            builder: (_, _) => const UserSettingsView(),
          ),
          GoRoute(
            path: Routes.today,
            builder: (_, _) => const SizedBox.shrink(key: Key('today-page')),
          ),
        ],
      );
    }

    Future<void> pumpView(
      WidgetTester tester, {
      String initialLocation = Routes.settings,
    }) {
      tester.view.physicalSize = const Size(1200, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      return tester.pumpPumpPumpItUP(
        const SizedBox.shrink(),
        router: buildRouter(initialLocation: initialLocation),
      );
    }

    testWidgets('renders every settings section', (tester) async {
      await pumpView(tester);

      expect(find.byType(ReminderStyleSection), findsOneWidget);
      expect(find.byType(MealScheduleSection), findsOneWidget);
      expect(find.byType(WeightSection), findsOneWidget);
      expect(find.byType(UsualMealsTile), findsOneWidget);
      expect(find.byType(AppearanceSection), findsOneWidget);
    });

    testWidgets('scrolls the goals section into view with focus=goals', (
      tester,
    ) async {
      await pumpView(tester, initialLocation: '${Routes.settings}?focus=goals');
      await tester.pumpAndSettle();

      expect(find.byType(GoalsSection), findsOneWidget);
    });

    testWidgets('the back button returns to today', (tester) async {
      await pumpView(tester);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('today-page')), findsOneWidget);
    });
  });
}
