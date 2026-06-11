import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_template/app/core/core.dart';
import 'package:flutter_template/app/feature/feature.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

void main() {
  const url = 'url';

  group(CoffeeBloc, () {
    late CoffeeRepository repo;
    late FileCacheService cacheService;

    setUp(() {
      initHydratedStorage();
      repo = MockCoffeeRepository();
      cacheService = MockFileCacheService();
    });

    blocTest<CoffeeBloc, CoffeeState>(
      'emits correct state on $LoadImages and fetches from $CoffeeRepository',
      setUp: () {
        when(() => repo.getCoffeeImage()).thenAnswer(
          (_) async => const Coffee(imageUrl: url),
        );
      },
      build: () => CoffeeBloc(repo, cacheService),
      act: (bloc) => bloc.add(const LoadImages(0)),
      expect: () => [
        isA<CoffeeState>().having(
          (s) => s.loadingState,
          'loadingState',
          equals(CoffeeLoadingState.loading),
        ),
        isA<CoffeeState>().having(
          (s) => s.images,
          'images',
          equals([url, url, url, url, url]),
        ),
        isA<CoffeeState>().having(
          (s) => s.loadingState,
          'loadingState',
          equals(CoffeeLoadingState.success),
        ),
      ],
      verify: (_) => verify(() => repo.getCoffeeImage()).called(5),
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'adds to favorites and calls getFile on $ToggleFavoriteImage',
      setUp: () {
        when(
          () => cacheService.getFile(any()),
        ).thenAnswer((_) async => File(''));
      },
      build: () => CoffeeBloc(repo, cacheService),
      act: (bloc) => bloc.add(const ToggleFavoriteImage(url)),
      expect: () => [
        isA<CoffeeState>().having(
          (s) => s.loadingState,
          'loadingState',
          equals(CoffeeLoadingState.saving),
        ),
        isA<CoffeeState>().having(
          (s) => s.favorites,
          'favorites',
          contains(url),
        ),
      ],
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'removes from favorites and calls removeFile on $ToggleFavoriteImage',
      setUp: () {
        when(() => cacheService.removeFile(any())).thenAnswer((_) async {});
      },
      build: () => CoffeeBloc(repo, cacheService),
      seed: () => const CoffeeState(favorites: [url]),
      act: (bloc) => bloc.add(const ToggleFavoriteImage(url)),
      expect: () => [
        isA<CoffeeState>().having(
          (s) => s.loadingState,
          'loadingState',
          equals(CoffeeLoadingState.saving),
        ),
        isA<CoffeeState>().having(
          (s) => s.favorites,
          'favorites',
          isEmpty,
        ),
      ],
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'keeps successfully fetched images when some requests fail',
      setUp: () {
        var calls = 0;
        when(() => repo.getCoffeeImage()).thenAnswer((_) async {
          calls++;
          if (calls == 1) throw Exception('error');
          return const Coffee(imageUrl: url);
        });
      },
      build: () => CoffeeBloc(repo, cacheService),
      act: (bloc) => bloc.add(const LoadImages(0)),
      expect: () => [
        isA<CoffeeState>().having(
          (s) => s.loadingState,
          'loadingState',
          equals(CoffeeLoadingState.loading),
        ),
        isA<CoffeeState>().having(
          (s) => s.images,
          'images',
          equals([url, url, url, url]),
        ),
        isA<CoffeeState>().having(
          (s) => s.loadingState,
          'loadingState',
          equals(CoffeeLoadingState.success),
        ),
      ],
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'keeps loadingState when images are already loaded on $LoadImages',
      build: () => CoffeeBloc(repo, cacheService),
      seed: () => const CoffeeState(
        images: [url, url, url, url, url],
        loadingState: CoffeeLoadingState.success,
      ),
      act: (bloc) => bloc.add(const LoadImages(0)),
      expect: () => [
        isA<CoffeeState>()
            .having(
              (s) => s.loadingState,
              'loadingState',
              equals(CoffeeLoadingState.success),
            )
            .having(
              (s) => s.imageWindow,
              'imageWindow',
              equals({0, 1, 2, 3, 4}),
            ),
      ],
      verify: (_) => verifyNever(() => repo.getCoffeeImage()),
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'clears feed except favorites on $ClearFeed',
      build: () => CoffeeBloc(repo, cacheService),
      seed: () => const CoffeeState(images: [url], favorites: [url]),
      act: (bloc) => bloc.add(const ClearFeed()),
      expect: () => [
        const CoffeeState(favorites: [url]),
      ],
    );

    test('toJson only persists favorites in $CoffeeBloc', () {
      final bloc = CoffeeBloc(repo, cacheService);
      const state = CoffeeState(images: [url], favorites: [url]);
      final json = bloc.toJson(state);
      expect(json['favorites'], equals([url]));
      expect(json['images'], isEmpty);
    });

    blocTest<CoffeeBloc, CoffeeState>(
      'emits failure state when _loadImages throws in $CoffeeBloc',
      setUp: () {
        when(() => repo.getCoffeeImage()).thenThrow(Exception('error'));
      },
      build: () => CoffeeBloc(repo, cacheService),
      act: (bloc) => bloc.add(const LoadImages(0)),
      expect: () => [
        isA<CoffeeState>().having(
          (s) => s.loadingState,
          'loadingState',
          equals(CoffeeLoadingState.loading),
        ),
        isA<CoffeeState>().having(
          (s) => s.loadingState,
          'loadingState',
          equals(CoffeeLoadingState.failure),
        ),
      ],
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'emits failure state when _toggleFavorite throws in $CoffeeBloc',
      setUp: () {
        when(() => cacheService.getFile(any())).thenThrow(Exception('error'));
      },
      build: () => CoffeeBloc(repo, cacheService),
      act: (bloc) => bloc.add(const ToggleFavoriteImage(url)),
      expect: () => [
        isA<CoffeeState>().having(
          (s) => s.loadingState,
          'loadingState',
          equals(CoffeeLoadingState.saving),
        ),
        isA<CoffeeState>().having(
          (s) => s.loadingState,
          'loadingState',
          equals(CoffeeLoadingState.failure),
        ),
      ],
    );

    test('fromJson returns correct $CoffeeState', () {
      final bloc = CoffeeBloc(repo, cacheService);
      final json = <String, dynamic>{
        'favorites': [url],
      };
      expect(bloc.fromJson(json).favorites, equals([url]));
    });
  });
}
