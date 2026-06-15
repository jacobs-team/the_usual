import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

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
    late StatefulNavigationShell navigationShell;

    setUp(() {
      navigationShell = MockStatefulNavigationShell();
      when(() => navigationShell.currentIndex).thenReturn(0);
      when(() => navigationShell.key).thenReturn(UniqueKey());
      when(
        () => navigationShell.goBranch(
          any(),
          initialLocation: any(named: 'initialLocation'),
        ),
      ).thenReturn(null);
    });

    testWidgets('shows a floating GlassContainer nav bar on small screens', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpPumpPumpItUP(
        NavigationWrapper(navigationShell: navigationShell),
      );

      expect(find.byType(GlassContainer), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
    });

    testWidgets('shows a NavigationRail on large screens', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpPumpPumpItUP(
        NavigationWrapper(navigationShell: navigationShell),
      );

      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(GlassContainer), findsNothing);
    });

    testWidgets('switches branch when a nav item is selected', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpPumpPumpItUP(
        NavigationWrapper(navigationShell: navigationShell),
      );

      // History is the unselected destination, so it shows its outlined icon.
      await tester.tap(find.byIcon(Icons.history_outlined));

      verify(
        () => navigationShell.goBranch(
          1,
          initialLocation: any(named: 'initialLocation'),
        ),
      ).called(1);
    });
  });
}
