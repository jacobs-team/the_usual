import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/core.dart';
import 'package:flutter_template/app/feature/feature.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

void main() {
  const url = 'url';
  group(CoffeeView, () {
    late CoffeeBloc coffeeBloc;
    late ConnectivityCubit connectivityCubit;

    setUp(() {
      initHydratedStorage();
      coffeeBloc = MockCoffeeBloc();
      connectivityCubit = MockConnectivityCubit();

      when(() => coffeeBloc.state).thenReturn(const CoffeeState());
      when(() => coffeeBloc.stream).thenAnswer((_) => const Stream.empty());
      when(() => connectivityCubit.state).thenReturn(true);
      when(
        () => connectivityCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
    });

    testWidgets('renders $CoffeeView and loads initial images', (tester) async {
      await tester.pumpPumpPumpItUP(
        deps: [coffeeBloc, connectivityCubit],
        const CoffeeView(),
      );

      expect(find.byType(CoffeeView), findsOneWidget);
      verify(() => coffeeBloc.add(const LoadImages(0))).called(1);
    });

    testWidgets('shows $SnackBar when loading fails in $CoffeeView', (
      tester,
    ) async {
      const errorMessage = 'error';
      whenListen(
        coffeeBloc,
        Stream.fromIterable([
          const CoffeeState(),
          const CoffeeState(
            loadingState: CoffeeLoadingState.failure,
            errorMessage: errorMessage,
          ),
        ]),
        initialState: const CoffeeState(),
      );

      await tester.pumpPumpPumpItUP(
        deps: [coffeeBloc, connectivityCubit],
        const CoffeeView(),
      );
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('triggers $ToggleFavoriteImage when $CoffeeImage is tapped', (
      tester,
    ) async {
      when(() => coffeeBloc.state).thenReturn(
        const CoffeeState(images: [url]),
      );

      await tester.pumpPumpPumpItUP(
        deps: [coffeeBloc, connectivityCubit],
        const CoffeeView(),
      );

      await tester.tap(find.byType(CoffeeImage));
      await tester.pump(kDoubleTapMinTime);
      await tester.tap(find.byType(CoffeeImage));
      await tester.pumpAndSettle();

      verify(() => coffeeBloc.add(const ToggleFavoriteImage(url))).called(1);
    });

    testWidgets('shows broken heart when unfavoriting a $CoffeeImage', (
      tester,
    ) async {
      when(() => coffeeBloc.state).thenReturn(
        const CoffeeState(images: [url], favorites: [url]),
      );

      await tester.pumpPumpPumpItUP(
        deps: [coffeeBloc, connectivityCubit],
        const CoffeeView(),
      );

      await tester.tap(find.byType(CoffeeImage));
      await tester.pump(kDoubleTapMinTime);
      await tester.tap(find.byType(CoffeeImage));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.heart_broken), findsOneWidget);
      verify(() => coffeeBloc.add(const ToggleFavoriteImage(url))).called(1);
    });

    testWidgets('precaches images when imageWindow changes in $CoffeeView', (
      tester,
    ) async {
      whenListen(
        coffeeBloc,
        Stream.fromIterable([
          const CoffeeState(images: [url], imageWindow: {0, 1}),
        ]),
        initialState: const CoffeeState(),
      );

      await tester.pumpPumpPumpItUP(
        deps: [coffeeBloc, connectivityCubit],
        const CoffeeView(),
      );
      await tester.pump();
      await tester.pump();

      expect(find.byType(CoffeeView), findsOneWidget);
      // The test HTTP client rejects the precache request for index 0;
      // absorb the resulting network image exception.
      tester.takeException();
    });

    testWidgets('triggers $LoadImages when page changes in $CoffeeView', (
      tester,
    ) async {
      when(() => coffeeBloc.state).thenReturn(
        const CoffeeState(images: [url, 'url2']),
      );

      await tester.pumpPumpPumpItUP(
        deps: [coffeeBloc, connectivityCubit],
        const CoffeeView(),
      );

      await tester.fling(find.byType(PageView), const Offset(0, -600), 1000);
      await tester.pumpAndSettle();

      verify(() => coffeeBloc.add(const LoadImages(1))).called(1);
    });

    testWidgets('triggers $LoadImages when $ConnectivityCubit reconnects', (
      tester,
    ) async {
      whenListen(
        connectivityCubit,
        Stream.fromIterable([false, true]),
        initialState: false,
      );

      await tester.pumpPumpPumpItUP(
        deps: [coffeeBloc, connectivityCubit],
        const CoffeeView(),
      );
      await tester.pump();

      verify(
        () => coffeeBloc.add(const LoadImages(0)),
      ).called(greaterThan(0));
    });
  });
}
