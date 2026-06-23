import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:the_usual/app/app.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(TheUsualAppBar, () {
    testWidgets('renders a Text title when no title widget is given', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        const Scaffold(appBar: TheUsualAppBar(title: 'History')),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.title, isA<Text>());
    });

    testWidgets('renders the title widget when provided', (tester) async {
      await tester.pumpPumpPumpItUP(
        const Scaffold(
          appBar: TheUsualAppBar(
            title: 'Today',
            titleWidget: Icon(Icons.calendar_today, key: Key('custom-title')),
          ),
        ),
      );

      expect(find.byKey(const Key('custom-title')), findsOneWidget);

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.title, isA<Icon>());
    });
    testWidgets('shows no history action when historyRoute is null', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        const Scaffold(appBar: TheUsualAppBar(title: 'Today')),
      );

      expect(find.byIcon(Icons.history_outlined), findsNothing);
    });

    testWidgets('shows a history action when historyRoute is set', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        const Scaffold(
          appBar: TheUsualAppBar(title: 'Today', historyRoute: '/history'),
        ),
      );

      expect(find.byIcon(Icons.history_outlined), findsOneWidget);
    });

    testWidgets('the history action pushes the history route', (tester) async {
      final router = GoRouter(
        initialLocation: '/start',
        routes: [
          GoRoute(
            path: '/start',
            builder: (context, state) => const Scaffold(
              appBar: TheUsualAppBar(title: 'Today', historyRoute: '/history'),
            ),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const Scaffold(
              body: SizedBox.shrink(key: Key('history-screen')),
            ),
          ),
        ],
      );

      await tester.pumpPumpPumpItUP(const SizedBox.shrink(), router: router);
      await tester.tap(find.byIcon(Icons.history_outlined));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('history-screen')), findsOneWidget);
    });
  });
}
