import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_template/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

void main() {
  const url = 'url';
  const url2 = 'url2';

  group(ExpandedImage, () {
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
      'renders $ExpandedImage and shows image memory in $ExpandedImage',
      (tester) async {
        when(() => coffeeBloc.state).thenReturn(
          const CoffeeState(favorites: [url]),
        );

        await tester.pumpPumpPumpItUP(
          deps: [coffeeBloc, fileCacheService],
          const ExpandedImage(url),
        );

        await tester.pumpAndSettle();

        expect(find.byType(ExpandedImage), findsOneWidget);
        expect(find.byType(InteractiveViewer), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      },
    );

    testWidgets('paginates through favorites in $ExpandedImage', (
      tester,
    ) async {
      when(() => coffeeBloc.state).thenReturn(
        const CoffeeState(favorites: [url, url2]),
      );

      await tester.pumpPumpPumpItUP(
        deps: [coffeeBloc, fileCacheService],
        const ExpandedImage(url),
      );

      await tester.pumpAndSettle();

      // Swipe to next image
      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pumpAndSettle();

      verify(() => fileCacheService.getBytes(url2)).called(1);
    });

    testWidgets(
      'shows $CircularProgressIndicator when loading in $ExpandedImage',
      (tester) async {
        final completer = Completer<Uint8List>();
        when(
          () => fileCacheService.getBytes(any()),
        ).thenAnswer((_) => completer.future);

        when(() => coffeeBloc.state).thenReturn(
          const CoffeeState(favorites: [url]),
        );

        await tester.pumpPumpPumpItUP(
          deps: [coffeeBloc, fileCacheService],
          const ExpandedImage(url),
        );

        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        completer.complete(transparentPixel);
        await tester.pumpAndSettle();

        expect(find.byType(CircularProgressIndicator), findsNothing);
      },
    );
  });
}
