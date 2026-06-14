import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';

/// {@template nutrition_summary}
/// A one-line, read-only summary of [Nutrition], e.g. "420 cal · 28P · 14F ·
/// 60C". Values that are unset are dropped, and an em dash is shown when none
/// are set. Pass [compact] to abbreviate large numbers (e.g. "2.0k").
/// {@endtemplate}
class NutritionSummary extends StatelessWidget {
  /// {@macro nutrition_summary}
  const NutritionSummary({
    required this.nutrition,
    this.style,
    this.compact = false,
    super.key,
  });

  /// The facts to summarize.
  final Nutrition nutrition;

  /// Style for the text. Defaults to the surrounding `bodyMedium`.
  final TextStyle? style;

  /// Whether to abbreviate large numbers, for tight spaces.
  final bool compact;

  String _format(int value) => compact ? value.compact : value.toString();

  @override
  Widget build(BuildContext context) {
    final calories = nutrition.calories;
    final protein = nutrition.protein;
    final fat = nutrition.fat;
    final carbs = nutrition.carbs;

    final parts = [
      if (calories != null) '${_format(calories)} cal',
      if (protein != null) '${_format(protein)}P',
      if (fat != null) '${_format(fat)}F',
      if (carbs != null) '${_format(carbs)}C',
    ];

    final text = parts.isEmpty ? '—' : parts.join(' · ');
    return Text(
      text,
      style: style ?? Theme.of(context).textTheme.bodyMedium,
    );
  }
}
