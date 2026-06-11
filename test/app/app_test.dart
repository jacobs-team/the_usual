import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_template/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/helpers.dart';

void main() {
  group(CoffeeApp, () {
    late DevToolsCubit devToolsCubit;

    setUp(() {
      initHydratedStorage();
      devToolsCubit = MockDevToolsCubit();
      when(() => devToolsCubit.state).thenReturn(const DevToolsState());
    });

    testWidgets('renders $CoffeeApp', (tester) async {
      await tester.pumpPumpPumpItUP(
        deps: [devToolsCubit],
        const CoffeeApp(),
      );
      expect(find.byType(CoffeeApp), findsOneWidget);
    });

    testWidgets('adds $ClearFeed when the user signs out', (tester) async {
      final authCubit = MockAuthCubit();
      final coffeeBloc = MockCoffeeBloc();
      final connectivityCubit = MockConnectivityCubit();

      whenListen(
        authCubit,
        Stream.fromIterable([const AuthState()]),
        initialState: const AuthState(user: 'user', token: 'token'),
      );
      when(() => coffeeBloc.state).thenReturn(const CoffeeState());
      when(() => coffeeBloc.stream).thenAnswer((_) => const Stream.empty());
      when(() => connectivityCubit.state).thenReturn(true);
      when(
        () => connectivityCubit.stream,
      ).thenAnswer((_) => const Stream.empty());

      await tester.pumpPumpPumpItUP(
        deps: [devToolsCubit, authCubit, coffeeBloc, connectivityCubit],
        const CoffeeApp(),
      );
      await tester.pump();

      verify(() => coffeeBloc.add(const ClearFeed())).called(1);
    });
  });
}
