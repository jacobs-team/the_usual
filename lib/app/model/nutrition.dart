import 'package:freezed_annotation/freezed_annotation.dart';

part 'nutrition.freezed.dart';
part 'nutrition.g.dart';

/// {@template nutrition}
/// The nutrition facts for a food: calories and the protein, fat, and carb
/// macros in grams. Each value is null until the user supplies it.
/// {@endtemplate}
@freezed
abstract class Nutrition with _$Nutrition {
  /// {@macro nutrition}
  const factory Nutrition({
    int? calories,
    int? protein,
    int? fat,
    int? carbs,
  }) = _Nutrition;

  const Nutrition._();

  factory Nutrition.fromJson(Map<String, dynamic> json) =>
      _$NutritionFromJson(json);

  /// Whether every value is still unset.
  bool get isEmpty =>
      calories == null && protein == null && fat == null && carbs == null;

  /// Adds two sets of facts, counting an unset value as zero. Used to total a
  /// list of entries, so every summed value is non-null.
  Nutrition operator +(Nutrition other) => Nutrition(
    calories: (calories ?? 0) + (other.calories ?? 0),
    protein: (protein ?? 0) + (other.protein ?? 0),
    fat: (fat ?? 0) + (other.fat ?? 0),
    carbs: (carbs ?? 0) + (other.carbs ?? 0),
  );

  /// Migrates a record's JSON from the legacy shape, where `calories` lived at
  /// the top level, to the current shape that nests it under `nutrition`.
  /// Records saved in the current shape (and ones with no calories) pass
  /// through unchanged. Used by the meal log and usual meal models so data
  /// stored before macros were tracked keeps its calories.
  static Map<String, dynamic> migrateLegacyJson(Map<String, dynamic> json) {
    if (json.containsKey('nutrition')) return json;
    final legacyCalories = json['calories'];
    if (legacyCalories == null) return json;
    return {
      ...json,
      'nutrition': {'calories': legacyCalories},
    };
  }
}
