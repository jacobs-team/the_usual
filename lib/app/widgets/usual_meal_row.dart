import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template usual_meal_row}
/// A card row for one usual meal: name, inline-editable calories, and a
/// remove button. Driven by callbacks so both onboarding and settings can
/// render it against their own bloc.
/// {@endtemplate}
class UsualMealRow extends StatelessWidget {
  /// {@macro usual_meal_row}
  const UsualMealRow({
    required this.usualMeal,
    required this.onCaloriesChanged,
    required this.onRemoved,
    super.key,
  });

  /// The usual meal being displayed.
  final UsualMeal usualMeal;

  /// Called with the parsed calories, or null when the field is cleared.
  final ValueChanged<int?> onCaloriesChanged;

  /// Called when the remove button is pressed.
  final VoidCallback onRemoved;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: AppDesign.spacing.sm),
      child: ListTile(
        title: Text(usualMeal.name, overflow: TextOverflow.ellipsis),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CalorieField(
              autoSize: true,
              dense: true,
              textAlign: TextAlign.right,
              initialValue: usualMeal.calories?.toString() ?? '',
              onChanged: onCaloriesChanged,
            ),
            SizedBox(width: AppDesign.spacing.xs),
            IconButton(icon: const Icon(Icons.close), onPressed: onRemoved),
          ],
        ),
      ),
    );
  }
}
