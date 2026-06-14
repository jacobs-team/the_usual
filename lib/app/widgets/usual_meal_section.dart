import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template usual_meal_section}
/// One meal's usual meals: a heading, the saved meals as editable rows, and
/// an inline composer as the last row to add a new one. Shared by onboarding
/// and settings so both look and behave identically.
/// {@endtemplate}
class UsualMealSection extends StatelessWidget {
  /// {@macro usual_meal_section}
  const UsualMealSection({
    required this.mealOfTheDay,
    required this.usualMeals,
    required this.onAdded,
    required this.onNutritionChanged,
    required this.onRemoved,
    super.key,
  });

  /// The meal this section represents.
  final MealOfTheDay mealOfTheDay;

  /// The saved usual meals for this meal.
  final List<UsualMeal> usualMeals;

  /// Called with the name and nutrition of a new usual meal.
  final void Function(String name, Nutrition nutrition) onAdded;

  /// Called with a usual meal's id and its new nutrition.
  final void Function(String id, Nutrition nutrition) onNutritionChanged;

  /// Called with the id of a usual meal to remove.
  final void Function(String id) onRemoved;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${mealOfTheDay.label} (${usualMeals.length})',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: AppDesign.spacing.sm),
        for (final usualMeal in usualMeals)
          UsualMealRow(
            key: ValueKey(usualMeal.id),
            usualMeal: usualMeal,
            onNutritionChanged: (nutrition) =>
                onNutritionChanged(usualMeal.id, nutrition),
            onRemoved: () => onRemoved(usualMeal.id),
          ),
        SizedBox(height: AppDesign.spacing.sm),
        UsualMealComposer(onAdd: onAdded),
      ],
    );
  }
}
