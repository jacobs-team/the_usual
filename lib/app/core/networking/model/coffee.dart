// coverage:ignore-file
// ignore_for_file: public_member_api_docs

import 'package:freezed_annotation/freezed_annotation.dart';
part 'coffee.freezed.dart';
part 'coffee.g.dart';

/// {@template coffee_image}
/// A data model with an image url.
/// {@endtemplate}
@freezed
abstract class Coffee with _$Coffee {
  /// {@macro coffee_image}
  const factory Coffee({
    /// The file path or URL string for the coffee image.
    @JsonKey(name: 'file') required String imageUrl,
  }) = _Coffee;

  factory Coffee.fromJson(Map<String, dynamic> json) => _$CoffeeFromJson(json);
}
