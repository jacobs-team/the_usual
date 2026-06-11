// ignore_for_file: public_member_api_docs, avoid_catches_without_on_clauses

import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter_template/app/core/networking/model/model.dart';
import 'package:flutter_template/app/core/networking/repository/coffee_repository.dart';
import 'package:flutter_template/app/core/service/file_cache_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part 'coffee_bloc.freezed.dart';
part 'coffee_bloc.g.dart';

/// {@template coffee_bloc}
/// A [HydratedBloc] that manages coffee image discovery and local caching.
///
/// This bloc handles:
/// * Fetching new coffee images via [CoffeeRepository].
/// * Prefetching logic to maintain a sliding window of pre cached images.
/// * Persistence of favorite images using [HydratedStorage] for the urls
/// and [FileCacheService] for the corresponding files.
/// {@endtemplate}
@singleton
class CoffeeBloc extends HydratedBloc<CoffeeEvent, CoffeeState> {
  /// {@macro coffee_bloc}
  CoffeeBloc(this._repo, this._cacheService) : super(const CoffeeState()) {
    on<CoffeeEvent>(
      (coffeEvent, emit) => coffeEvent.map(
        loadImages: (value) => _loadImages(value, emit),
        toggleFavoriteImage: (value) => _toggleFavorite(value, emit),
        clearFeed: (value) => emit(CoffeeState(favorites: state.favorites)),
      ),
    );
  }

  final CoffeeRepository _repo;
  final FileCacheService _cacheService;

  Future<void> _toggleFavorite(
    ToggleFavoriteImage event,
    Emitter<CoffeeState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          errorMessage: null,
          loadingState: CoffeeLoadingState.saving,
        ),
      );

      final updatedSavedImages = List<String>.from(state.favorites);

      if (updatedSavedImages.contains(event.url)) {
        await _cacheService.removeFile(event.url);
        updatedSavedImages.remove(event.url);
      } else {
        await _cacheService.getFile(event.url);
        updatedSavedImages.add(event.url);
      }
      emit(
        state.copyWith(
          favorites: updatedSavedImages,
          loadingState: CoffeeLoadingState.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: 'Failed to toggle favorite image',
          loadingState: CoffeeLoadingState.failure,
        ),
      );
      log(e.toString());
    }
  }

  Future<void> _loadImages(
    LoadImages event,
    Emitter<CoffeeState> emit,
  ) async {
    try {
      final numImagesToLoad = math.max(
        0,
        event.currentImage - state.images.length + 5,
      );

      emit(
        state.copyWith(
          loadingState: numImagesToLoad > 0
              ? CoffeeLoadingState.loading
              : state.loadingState,
          errorMessage: null,
          currentImage: event.currentImage,
        ),
      );

      if (numImagesToLoad > 0) {
        final results = await Future.wait(
          List.generate(numImagesToLoad, (_) async {
            try {
              return await _repo.getCoffeeImage();
            } catch (e) {
              log('failed to load image: $e');
              return null;
            }
          }),
        );
        final newImages = results.whereType<Coffee>().toList();

        if (newImages.isEmpty) {
          throw Exception('Failed to load any images');
        }

        emit(
          state.copyWith(
            images: List.from(state.images)
              ..addAll(newImages.map((image) => image.imageUrl)),
          ),
        );
      }

      final totalImages = state.images.length;
      final windowStart = (event.currentImage - 5).clamp(
        0,
        totalImages - 1,
      );
      final windowEnd = (event.currentImage + 5).clamp(0, totalImages - 1);
      final imageWindow = <int>{
        for (int i = windowStart; i <= windowEnd; i++) i,
      };

      emit(
        state.copyWith(
          imageWindow: imageWindow,
          loadingState: numImagesToLoad > 0
              ? CoffeeLoadingState.success
              : state.loadingState,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loadingState: CoffeeLoadingState.failure,
          errorMessage: 'Failed to load image',
        ),
      );
      log(e.toString());
    }
  }

  @override
  CoffeeState fromJson(Map<String, dynamic> json) {
    return CoffeeState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(CoffeeState state) {
    // Persist only the favorites list to local storage.
    return CoffeeState(favorites: state.favorites).toJson();
  }
}

@Freezed()
abstract class CoffeeEvent with _$CoffeeEvent {
  const factory CoffeeEvent.loadImages(int currentImage) = LoadImages;
  const factory CoffeeEvent.toggleFavoriteImage(String url) =
      ToggleFavoriteImage;
  const factory CoffeeEvent.clearFeed() = ClearFeed;
}

@freezed
abstract class CoffeeState with _$CoffeeState {
  /// {@macro coffee_state}
  const factory CoffeeState({
    @Default(CoffeeLoadingState.init) CoffeeLoadingState loadingState,
    @Default(0) int currentImage,
    String? errorMessage,
    @Default([]) List<String> images,
    @Default([]) List<String> favorites,

    /// A set of indices representing the active sliding window of
    /// precached images.
    @Default({}) Set<int> imageWindow,
  }) = _CoffeeState;

  factory CoffeeState.fromJson(Map<String, dynamic> json) =>
      _$CoffeeStateFromJson(json);
}

enum CoffeeLoadingState { init, loading, saving, success, failure }
