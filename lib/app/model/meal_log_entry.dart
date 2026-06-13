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
  const factory MealLogEntry({
    required String id,
    required DateTime loggedAt,
    required MealOfTheDay mealOfTheDay,
    required String name,
    int? calories,
    String? usualMealId,
    String? photoPath,
  }) = _MealLogEntry;

  factory MealLogEntry.fromJson(Map<String, dynamic> json) =>
      _$MealLogEntryFromJson(json);
}
