import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template nutrition_summary}
/// A one-line nutrition summary with each value bolded and the macros
/// color-coded to match the daily nutrition bar: calories and separators in the
/// surrounding text color, protein teal, carbs blue, fat amber. Unset values
/// are dropped; an em dash shows when none are set.
///
/// Size and base color come from the ambient [DefaultTextStyle], so wrap the
/// call site in `DefaultTextStyle.merge` to control them.
/// {@endtemplate}
class NutritionSummary extends StatelessWidget {
  /// {@macro nutrition_summary}
  const NutritionSummary(this.nutrition, {super.key});

  /// The nutrition to summarize.
  final Nutrition nutrition;

  @override
  Widget build(BuildContext context) {
    const boldStyle = TextStyle(fontWeight: FontWeight.w700);

    final parts = <(String, Color?)>[
      if (nutrition.calories != null) ('${nutrition.calories} cal', null),
      if (nutrition.protein != null)
        ('${nutrition.protein}P', AppPalette.proteinMacro),
      if (nutrition.carbs != null)
        ('${nutrition.carbs}C', AppPalette.carbsMacro),
      if (nutrition.fat != null) ('${nutrition.fat}F', AppPalette.fatMacro),
    ];

    if (parts.isEmpty) {
      return const Text('—', style: boldStyle);
    }

    return Text.rich(
      TextSpan(
        children: [
          for (final (index, (text, color)) in parts.indexed) ...[
            if (index > 0) const TextSpan(text: ' · '),
            TextSpan(
              text: text,
              style: color == null ? null : TextStyle(color: color),
            ),
          ],
        ],
      ),
      style: boldStyle,
    );
  }
}
