import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/core.dart';
import 'package:flutter_template/app/feature/feature.dart';
import 'package:flutter_template/l10n/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

void main() {
  const coffeeImage = 'coffee_image';

  group(FavoriteImage, () {
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

    testWidgets('renders $FavoriteImage and shows image from cache', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        deps: [coffeeBloc, fileCacheService],
        const FavoriteImage(coffeeImage),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
      verify(() => fileCacheService.getBytes(coffeeImage)).called(1);
    });

    testWidgets('triggers $ToggleFavoriteImage when remove icon is pressed', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        deps: [coffeeBloc, fileCacheService],
        const FavoriteImage(coffeeImage),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.heart_broken));

      verify(
        () => coffeeBloc.add(const ToggleFavoriteImage(coffeeImage)),
      ).called(1);
    });

    testWidgets('opens dialog with $ExpandedImage when tapped', (tester) async {
      await tester.pumpPumpPumpItUP(
        deps: [coffeeBloc, fileCacheService],
        const FavoriteImage(coffeeImage),
      );

      await tester.pumpAndSettle();
      final imageGesture = find
          .descendant(
            of: find.byType(FavoriteImage),
            matching: find.byType(GestureDetector),
          )
          .first;

      await tester.tap(imageGesture);
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(ExpandedImage), findsOneWidget);
      expect(find.byType(Dismissible), findsOneWidget);
    });

    testWidgets('closes dialog when $ExpandedImage is dismissed', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        deps: [coffeeBloc, fileCacheService],
        const SizedBox(),
      );

      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) =>
                const Scaffold(body: FavoriteImage(coffeeImage)),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );
      await tester.pumpAndSettle();

      final imageGesture = find
          .descendant(
            of: find.byType(FavoriteImage),
            matching: find.byType(GestureDetector),
          )
          .first;
      await tester.tap(imageGesture);
      await tester.pumpAndSettle();

      expect(find.byType(ExpandedImage), findsOneWidget);

      await tester.fling(find.byType(Dismissible), const Offset(0, 500), 1000);
      await tester.pumpAndSettle();

      expect(find.byType(ExpandedImage), findsNothing);
    });

    testWidgets('shows $CircularProgressIndicator while loading file', (
      tester,
    ) async {
      final completer = Completer<Uint8List>();
      when(
        () => fileCacheService.getBytes(any()),
      ).thenAnswer((_) => completer.future);

      await tester.pumpPumpPumpItUP(
        deps: [coffeeBloc, fileCacheService],
        const FavoriteImage(coffeeImage),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(transparentPixel);
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
