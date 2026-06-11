import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/core.dart';
import 'package:flutter_template/app/navigation/navigation.dart';
import 'package:flutter_template/app/widgets/widgets.dart';
import 'package:flutter_template/l10n/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockStatefulNavigationShell extends Mock
    implements StatefulNavigationShell {
  @override
  Key? get key => super.noSuchMethod(Invocation.getter(#key)) as Key?;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'MockStatefulNavigationShell';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {}

  @override
  StatefulElement createElement() => StatefulElement(this);

  @override
  State<StatefulWidget> createState() => _MockState();
}

class _MockState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

void main() {
  group(NavigationWrapper, () {
    late AuthCubit authCubit;
    late ConnectivityCubit connectivityCubit;
    late StatefulNavigationShell navigationShell;

    setUp(() {
      initHydratedStorage();
      authCubit = MockAuthCubit();
      connectivityCubit = MockConnectivityCubit();
      navigationShell = MockStatefulNavigationShell();
      when(() => navigationShell.currentIndex).thenReturn(0);
      when(() => navigationShell.key).thenReturn(UniqueKey());
      when(() => authCubit.state).thenReturn(const AuthState());
      when(() => connectivityCubit.state).thenReturn(true);
      when(
        () => connectivityCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
    });

    testWidgets(
      'renders $NavigationWrapper with floating $GlassContainer nav bar '
      'on small screens',
      (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpPumpPumpItUP(
          deps: [authCubit, connectivityCubit],
          NavigationWrapper(navigationShell: navigationShell),
        );

        expect(find.byType(GlassContainer), findsOneWidget);
        expect(find.byType(NavigationRail), findsNothing);

        addTearDown(tester.view.resetPhysicalSize);
      },
    );

    testWidgets(
      'renders $NavigationWrapper with $NavigationRail on large screens',
      (tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpPumpPumpItUP(
          deps: [authCubit, connectivityCubit],
          NavigationWrapper(navigationShell: navigationShell),
        );

        expect(find.byType(NavigationRail), findsOneWidget);
        expect(find.byType(GlassContainer), findsNothing);

        addTearDown(tester.view.resetPhysicalSize);
      },
    );

    testWidgets(
      'triggers logout when logout button is pressed in $NavigationWrapper',
      (tester) async {
        when(() => authCubit.logout()).thenAnswer((_) async {});

        await tester.pumpPumpPumpItUP(
          deps: [authCubit, connectivityCubit],
          NavigationWrapper(navigationShell: navigationShell),
        );

        await tester.tap(find.byIcon(Icons.logout));
        verify(() => authCubit.logout()).called(1);
      },
    );

    testWidgets(
      'shows "No connection" banner when $ConnectivityCubit is false',
      (tester) async {
        when(() => connectivityCubit.state).thenReturn(false);

        await tester.pumpPumpPumpItUP(
          deps: [authCubit, connectivityCubit],
          NavigationWrapper(navigationShell: navigationShell),
        );

        expect(find.text('No connection'), findsOneWidget);
        expect(
          find.byIcon(Icons.signal_cellular_nodata),
          findsOneWidget,
        );
      },
    );
    testWidgets(
      'calls goBranch when floating nav item is selected on small screens',
      (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        when(
          () => navigationShell.goBranch(
            any(),
            initialLocation: any(named: 'initialLocation'),
          ),
        ).thenReturn(null);

        await tester.pumpPumpPumpItUP(
          deps: [authCubit, connectivityCubit],
          NavigationWrapper(navigationShell: navigationShell),
        );

        await tester.tap(find.byIcon(Icons.favorite_outline));

        verify(
          () => navigationShell.goBranch(
            1,
            initialLocation: any(named: 'initialLocation'),
          ),
        ).called(1);
      },
    );

    testWidgets('navigates to dev tools when code button is pressed', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        deps: [authCubit, connectivityCubit],
        const SizedBox(),
      );

      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) =>
                NavigationWrapper(navigationShell: navigationShell),
          ),
          GoRoute(
            path: Routes.devTools,
            builder: (context, state) =>
                const Scaffold(key: Key('devToolsStub')),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => Layout(child: child!),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.code));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('devToolsStub')), findsOneWidget);
    });

    testWidgets('calls goBranch when navigation item is selected', (
      tester,
    ) async {
      when(
        () => navigationShell.goBranch(
          any(),
          initialLocation: any(named: 'initialLocation'),
        ),
      ).thenReturn(null);

      await tester.pumpPumpPumpItUP(
        deps: [authCubit, connectivityCubit],
        NavigationWrapper(navigationShell: navigationShell),
      );

      final BuildContext context = tester.element(
        find.byType(NavigationWrapper),
      );
      final l10n = AppLocalizations.of(context);
      final favoritesLabel = AppRouter.destinations(l10n)[1].label;
      await tester.tap(find.text(favoritesLabel));

      verify(
        () => navigationShell.goBranch(
          1,
          initialLocation: any(named: 'initialLocation'),
        ),
      ).called(1);
    });
  });
}
