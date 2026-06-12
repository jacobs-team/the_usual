import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../helpers/helpers.dart';

void main() {
  group(TheUsualsApp, () {
    late DevToolsCubit devToolsCubit;

    setUp(() {
      initHydratedStorage();
      devToolsCubit = MockDevToolsCubit();
      when(() => devToolsCubit.state).thenReturn(const DevToolsState());
    });

    testWidgets('renders $TheUsualsApp', (tester) async {
      await tester.pumpPumpPumpItUP(
        deps: [devToolsCubit],
        const TheUsualsApp(),
      );
      expect(find.byType(TheUsualsApp), findsOneWidget);
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
        const TheUsualsApp(),
      );
      await tester.pump();

      verify(() => coffeeBloc.add(const ClearFeed())).called(1);
    });
  });
}
