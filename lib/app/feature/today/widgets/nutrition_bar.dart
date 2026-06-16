import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template nutrition_bar}
/// A full-width segmented bar summarizing the day's macros against the calorie
/// goal. The bar's width represents [calorieGoal]; the colored portion spans
/// the share of that goal already eaten — consumed calories over the goal — and
/// is split into protein, carbs, and fat segments sized by their gram values.
/// Each segment is labeled with its macro name, ellipsized when it doesn't fit.
///
/// With no [calorieGoal] the macros fill the whole bar instead of a portion of
/// it. When consumed calories reach or exceed the goal the colored portion
/// fills the bar and a red border and shadow mark that the limit was hit.
/// {@endtemplate}
class NutritionBar extends StatelessWidget {
  /// {@macro nutrition_bar}
  const NutritionBar({
    required this.nutrition,
    required this.calorieGoal,
    super.key,
  });

  /// The day's total nutrition.
  final Nutrition nutrition;

  /// The user's daily calorie target, or null when they haven't set one.
  final int? calorieGoal;

  static const double _height = 32;

  /// Flex weights are integers, so widths are computed on a fixed scale to keep
  /// small gram differences from collapsing to the same width.
  static const int _flexScale = 10000;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final consumedCalories = nutrition.calories ?? 0;
    final calorieGoal = this.calorieGoal;
    final hasGoal = calorieGoal != null && calorieGoal > 0;
    final filledFraction = hasGoal
        ? (consumedCalories / calorieGoal).clamp(0.0, 1.0)
        : 1.0;
    final reachedGoal = hasGoal && consumedCalories >= calorieGoal;

    final macroSegments =
        [
          (
            name: 'Protein',
            grams: nutrition.protein ?? 0,
            color: AppPalette.proteinMacro,
          ),
          (
            name: 'Carbs',
            grams: nutrition.carbs ?? 0,
            color: AppPalette.carbsMacro,
          ),
          (name: 'Fat', grams: nutrition.fat ?? 0, color: AppPalette.fatMacro),
        ].where((macroSegment) => macroSegment.grams > 0).toList();
    final totalGrams = macroSegments.fold(
      0,
      (sum, macroSegment) => sum + macroSegment.grams,
    );

    // Each macro takes its gram share of the filled portion; the rest of the
    // bar — calories not yet eaten — stays empty.
    final segmentFlexes = [
      for (final macroSegment in macroSegments)
        (
          macroSegment: macroSegment,
          flex:
              (filledFraction * macroSegment.grams / totalGrams * _flexScale)
                  .round(),
        ),
    ];
    final emptyFlex = ((1 - filledFraction) * _flexScale).round();
    final remainingCalories = hasGoal ? calorieGoal - consumedCalories : 0;

    final labelStyle = theme.textTheme.labelMedium?.copyWith(
      color: AppPalette.onMacro,
      fontWeight: FontWeight.w600,
    );
    final remainingStyle = theme.textTheme.labelMedium?.copyWith(
      color: colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w600,
    );

    final borderRadius = BorderRadius.circular(AppDesign.radius.sm);
    return Container(
      height: _height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: borderRadius,
        boxShadow: reachedGoal
            ? [
                BoxShadow(
                  color: colorScheme.error.withValues(alpha: 0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      // Painted over the segments so the rounded border stays crisp at the
      // corners instead of being overrun by the square segment fills.
      foregroundDecoration: reachedGoal
          ? BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(color: colorScheme.error, width: 2),
            )
          : null,
      child: Row(
        children: [
          for (final segmentFlex in segmentFlexes)
            if (segmentFlex.flex > 0)
              Expanded(
                flex: segmentFlex.flex,
                child: ColoredBox(
                  color: segmentFlex.macroSegment.color,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDesign.spacing.xs,
                      ),
                      child: Text(
                        segmentFlex.macroSegment.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: labelStyle,
                      ),
                    ),
                  ),
                ),
              ),
          if (emptyFlex > 0)
            Expanded(
              flex: emptyFlex,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDesign.spacing.xs,
                  ),
                  child: Text(
                    '$remainingCalories cal left',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: remainingStyle,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
