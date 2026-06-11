import 'package:flutter_template/app/feature/feature.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(DevToolsView, () {
    late DevToolsCubit devToolsCubit;

    setUp(() {
      initHydratedStorage();
      devToolsCubit = MockDevToolsCubit();

      when(() => devToolsCubit.state).thenReturn(const DevToolsState());
      when(() => devToolsCubit.stream).thenAnswer((_) => const Stream.empty());
    });

    testWidgets('renders $DevToolsView', (tester) async {
      await tester.pumpPumpPumpItUP(
        deps: [devToolsCubit],
        const DevToolsView(),
      );

      expect(find.byType(DevToolsView), findsOneWidget);
      expect(find.text('Dev Tools'), findsOneWidget);
    });

    testWidgets('triggers toggleDebugApi when Debug API switch is toggled', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        deps: [devToolsCubit],
        const DevToolsView(),
      );

      await tester.tap(find.text('Debug API'));

      verify(() => devToolsCubit.toggleDebugApi()).called(1);
    });

    testWidgets('triggers toggleDarkMode when Dark mode switch is toggled', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        deps: [devToolsCubit],
        const DevToolsView(),
      );

      await tester.tap(find.text('Dark mode'));

      verify(() => devToolsCubit.toggleDarkMode()).called(1);
    });
  });
}
