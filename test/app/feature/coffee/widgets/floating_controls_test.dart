import 'package:flutter/material.dart';
import 'package:flutter_template/app/feature/coffee/widgets/floating_controls.dart';
import 'package:flutter_template/app/feature/feature.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

class MockPageController extends Mock implements PageController {}

class FakeCurve extends Fake implements Curve {}

void main() {
  const url = 'url';

  setUpAll(() {
    registerFallbackValue(const Duration(milliseconds: 10));
    registerFallbackValue(FakeCurve());
  });

  group(FloatingControls, () {
    late CoffeeBloc coffeeBloc;
    late PageController pageController;

    setUp(() {
      initHydratedStorage();
      coffeeBloc = MockCoffeeBloc();
      pageController = MockPageController();

      when(() => coffeeBloc.state).thenReturn(const CoffeeState());
      when(() => coffeeBloc.stream).thenAnswer((_) => const Stream.empty());

      when(
        () => pageController.nextPage(
          duration: any(named: 'duration'),
          curve: any(named: 'curve'),
        ),
      ).thenAnswer((_) => Future.value());

      when(
        () => pageController.previousPage(
          duration: any(named: 'duration'),
          curve: any(named: 'curve'),
        ),
      ).thenAnswer((_) => Future.value());
    });

    testWidgets('triggers previousPage when up button is pressed', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        deps: [coffeeBloc],
        FloatingControls(pageController: pageController),
      );

      await tester.tap(find.byIcon(Icons.arrow_upward));

      verify(
        () => pageController.previousPage(
          duration: any(named: 'duration'),
          curve: any(named: 'curve'),
        ),
      ).called(1);
    });

    testWidgets('triggers nextPage when down button is pressed', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        deps: [coffeeBloc],
        FloatingControls(pageController: pageController),
      );

      await tester.tap(find.byIcon(Icons.arrow_downward));

      verify(
        () => pageController.nextPage(
          duration: any(named: 'duration'),
          curve: any(named: 'curve'),
        ),
      ).called(1);
    });

    testWidgets(
      'triggers $ToggleFavoriteImage when favorite button is pressed',
      (tester) async {
        when(() => coffeeBloc.state).thenReturn(
          const CoffeeState(images: [url]),
        );

        await tester.pumpPumpPumpItUP(
          deps: [coffeeBloc],
          FloatingControls(pageController: pageController),
        );

        await tester.tap(find.byIcon(Icons.favorite_outline));

        verify(() => coffeeBloc.add(const ToggleFavoriteImage(url))).called(1);
      },
    );

    testWidgets(
      'renders filled favorite icon when current image is favorited',
      (tester) async {
        when(() => coffeeBloc.state).thenReturn(
          const CoffeeState(images: [url], favorites: [url]),
        );

        await tester.pumpPumpPumpItUP(
          deps: [coffeeBloc],
          FloatingControls(pageController: pageController),
        );

        expect(find.byIcon(Icons.favorite), findsOneWidget);
      },
    );

    testWidgets(
      'renders $CircularProgressIndicator when saving in $FloatingControls',
      (tester) async {
        when(() => coffeeBloc.state).thenReturn(
          const CoffeeState(
            images: [url],
            loadingState: CoffeeLoadingState.saving,
          ),
        );

        await tester.pumpPumpPumpItUP(
          deps: [coffeeBloc],
          FloatingControls(pageController: pageController),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );
  });
}
