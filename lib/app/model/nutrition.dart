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

  /// A one-line summary for display, e.g. "420 cal · 28P · 14F · 60C". Unset
  /// values are dropped; an em dash is shown when none are set.
  String get summary {
    final parts = [
      if (calories != null) '$calories cal',
      if (protein != null) '${protein}P',
      if (fat != null) '${fat}F',
      if (carbs != null) '${carbs}C',
    ];
    return parts.isEmpty ? '—' : parts.join(' · ');
  }

  /// Adds two sets of facts, counting an unset value as zero. Used to total a
  /// list of entries, so every summed value is non-null.
  Nutrition operator +(Nutrition other) => Nutrition(
    calories: (calories ?? 0) + (other.calories ?? 0),
    protein: (protein ?? 0) + (other.protein ?? 0),
    fat: (fat ?? 0) + (other.fat ?? 0),
    carbs: (carbs ?? 0) + (other.carbs ?? 0),
  );

  /// Scales each value by [factor], leaving unset values unset so the summary
  /// still drops them. Used to apply a logged entry's quantity to its per-unit
  /// facts.
  Nutrition operator *(int factor) => Nutrition(
    calories: calories == null ? null : calories! * factor,
    protein: protein == null ? null : protein! * factor,
    fat: fat == null ? null : fat! * factor,
    carbs: carbs == null ? null : carbs! * factor,
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
