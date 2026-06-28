import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_usual/app/app.dart';

part 'meal_log_entry.freezed.dart';
part 'meal_log_entry.g.dart';

/// {@template meal_log_entry}
/// A single thing the user logged eating, at a point in time.
/// {@endtemplate}
@freezed
abstract class MealLogEntry with _$MealLogEntry {
  /// {@macro meal_log_entry}
  @JsonSerializable(explicitToJson: true)
  const factory MealLogEntry({
    required String id,
    required DateTime loggedAt,
    required MealOfTheDay mealOfTheDay,
    required String name,
    @Default(Nutrition()) Nutrition nutrition,
    @Default(1) double quantity,
    String? usualMealId,
    String? photoPath,
    @Default(<MealComponent>[]) List<MealComponent> components,
  }) = _MealLogEntry;

  const MealLogEntry._();

  factory MealLogEntry.fromJson(Map<String, dynamic> json) =>
      _$MealLogEntryFromJson(Nutrition.migrateLegacyJson(json));

  /// The entry's nutrition with its [quantity] applied. The stored [nutrition]
  /// is per unit; this is what every total and summary uses.
  Nutrition get scaledNutrition => nutrition * quantity;
}
