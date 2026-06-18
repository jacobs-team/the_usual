import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal_photo.freezed.dart';

/// {@template meal_photo}
/// A photo chosen for AI meal estimation: its raw [bytes] and the [mediaType]
/// MIME string Claude needs (`image/jpeg`, `image/png`, `image/gif`, or
/// `image/webp`). Shared by the photo picker, the entry bloc, the AI
/// repository/client, and the share-ingest service.
/// {@endtemplate}
@freezed
abstract class MealPhoto with _$MealPhoto {
  /// {@macro meal_photo}
  const factory MealPhoto({
    required Uint8List bytes,
    @Default('image/jpeg') String mediaType,
  }) = _MealPhoto;
}
