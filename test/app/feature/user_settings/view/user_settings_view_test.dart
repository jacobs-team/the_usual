import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(UserSettingsView, () {
    GoRouter buildRouter() {
      return GoRouter(
        initialLocation: Routes.settings,
        routes: [
          GoRoute(
            path: Routes.settings,
            builder: (_, _) => const UserSettingsView(),
          ),
          GoRoute(
            path: Routes.today,
            builder: (_, _) => const Text('today-page'),
          ),
        ],
      );
    }

    Future<void> pumpView(WidgetTester tester) {
      tester.view.physicalSize = const Size(1200, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      return tester.pumpPumpPumpItUP(
        const SizedBox.shrink(),
        router: buildRouter(),
      );
    }

    testWidgets('renders every settings section', (tester) async {
      await pumpView(tester);

      expect(find.text('Settings'), findsOneWidget);
      expect(find.byType(ReminderStyleSection), findsOneWidget);
      expect(find.byType(MealScheduleSection), findsOneWidget);
      expect(find.byType(WeightSection), findsOneWidget);
      expect(find.byType(UsualMealsTile), findsOneWidget);
      expect(find.byType(AppearanceSection), findsOneWidget);
      expect(find.byType(ResetAppStateTile), findsOneWidget);
    });

    testWidgets('the back button returns to today', (tester) async {
      await pumpView(tester);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.text('today-page'), findsOneWidget);
    });
  });
}
