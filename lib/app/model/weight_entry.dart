import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_usual/app/app.dart';

part 'weight_entry.freezed.dart';
part 'weight_entry.g.dart';

/// {@template weight_entry}
/// A single weigh-in: the weight and the unit it was recorded in, at a point
/// in time.
/// {@endtemplate}
@freezed
abstract class WeightEntry with _$WeightEntry {
  /// {@macro weight_entry}
  const factory WeightEntry({
    required String id,
    required DateTime loggedAt,
    required double weight,
    required WeightUnit weightUnit,
  }) = _WeightEntry;

  const WeightEntry._();

  factory WeightEntry.fromJson(Map<String, dynamic> json) =>
      _$WeightEntryFromJson(json);

  /// The weight and unit for display, e.g. "165 lb". Drops a trailing ".0".
  String get label {
    final value = weight == weight.roundToDouble()
        ? weight.toInt().toString()
        : weight.toString();
    return '$value ${weightUnit.name}';
  }
}
