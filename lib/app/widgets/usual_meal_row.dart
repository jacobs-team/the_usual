import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template usual_meal_row}
/// A card for one usual meal: its name with a remove button, and
/// inline-editable nutrition fields beneath. Driven by callbacks so both
/// onboarding and settings can render it against their own bloc.
/// {@endtemplate}
class UsualMealRow extends StatelessWidget {
  /// {@macro usual_meal_row}
  const UsualMealRow({
    required this.usualMeal,
    required this.onNutritionChanged,
    required this.onRemoved,
    super.key,
  });

  /// The usual meal being displayed.
  final UsualMeal usualMeal;

  /// Called with the parsed nutrition whenever a field changes.
  final ValueChanged<Nutrition> onNutritionChanged;

  /// Called when the remove button is pressed.
  final VoidCallback onRemoved;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: AppDesign.spacing.sm),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppDesign.spacing.lg,
          AppDesign.spacing.sm,
          AppDesign.spacing.sm,
          AppDesign.spacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    usualMeal.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onRemoved,
                ),
              ],
            ),
            NutritionFields(
              dense: true,
              initial: usualMeal.nutrition,
              onChanged: onNutritionChanged,
            ),
          ],
        ),
      ),
    );
  }
}
