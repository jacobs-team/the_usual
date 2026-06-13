import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';

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
    required this.onCaloriesChanged,
    required this.onRemoved,
    super.key,
  });

  /// The meal this section represents.
  final MealOfTheDay mealOfTheDay;

  /// The saved usual meals for this meal.
  final List<UsualMeal> usualMeals;

  /// Called with the name and optional calories of a new usual meal.
  final void Function(String name, int? calories) onAdded;

  /// Called with a usual meal's id and its new calories.
  final void Function(String id, int? calories) onCaloriesChanged;

  /// Called with the id of a usual meal to remove.
  final void Function(String id) onRemoved;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionLabel(
          '${mealOfTheDay.label.toUpperCase()} (${usualMeals.length})',
        ),
        const SizedBox(height: 8),
        for (final usualMeal in usualMeals)
          UsualMealRow(
            key: ValueKey(usualMeal.id),
            usualMeal: usualMeal,
            onCaloriesChanged: (calories) =>
                onCaloriesChanged(usualMeal.id, calories),
            onRemoved: () => onRemoved(usualMeal.id),
          ),
        const SizedBox(height: 8),
        UsualMealComposer(onAdd: onAdded),
      ],
    );
  }
}
