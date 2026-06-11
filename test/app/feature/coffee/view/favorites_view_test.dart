import 'package:flutter/material.dart';
import 'package:flutter_template/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

void main() {
  const url = 'url';

  group(FavoritesView, () {
    late CoffeeBloc coffeeBloc;
    late FileCacheService fileCacheService;

    setUp(() {
      initHydratedStorage();
      coffeeBloc = MockCoffeeBloc();
      fileCacheService = MockFileCacheService();

      when(() => coffeeBloc.state).thenReturn(const CoffeeState());
      when(() => coffeeBloc.stream).thenAnswer((_) => const Stream.empty());

      when(() => fileCacheService.getBytes(any())).thenAnswer(
        (_) async => transparentPixel,
      );
    });

    testWidgets(
      'renders empty state message when favorites is empty in $FavoritesView',
      (tester) async {
        await tester.pumpPumpPumpItUP(
          deps: [coffeeBloc, fileCacheService],
          const FavoritesView(),
        );

        expect(find.text('No saved images'), findsOneWidget);
      },
    );

    testWidgets(
      'renders list of $FavoriteImage when favorites exist '
      'in $FavoritesView',
      (tester) async {
        when(() => coffeeBloc.state).thenReturn(
          const CoffeeState(favorites: [url, 'url2']),
        );

        await tester.pumpPumpPumpItUP(
          deps: [coffeeBloc, fileCacheService],
          const FavoritesView(),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ListView), findsOneWidget);
        expect(find.byKey(const ValueKey(url)), findsOneWidget);

        await tester.scrollUntilVisible(
          find.byKey(const ValueKey('url2')),
          200,
        );
        expect(find.byKey(const ValueKey('url2')), findsOneWidget);
      },
    );
  });
}
