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
    required this.expandedByDefault,
    required this.onAdded,
    required this.onNutritionChanged,
    required this.onRemoved,
    this.showHeader = true,
    super.key,
  });

  /// The meal this section represents.
  final MealOfTheDay mealOfTheDay;

  /// The saved usual meals for this meal.
  final List<UsualMeal> usualMeals;

  /// Whether each meal's nutrition fields start expanded for editing.
  final bool expandedByDefault;

  /// Whether to show the meal-name header. Hidden where the surrounding UI
  /// already names the meal, e.g. the settings tab bar.
  final bool showHeader;

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
        if (showHeader) ...[
          Text(
            '${mealOfTheDay.label} (${usualMeals.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: AppDesign.spacing.sm),
        ],
        for (final usualMeal in usualMeals)
          Card(
            key: ValueKey(usualMeal.id),
            margin: EdgeInsets.only(bottom: AppDesign.spacing.sm),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppDesign.spacing.lg,
                AppDesign.spacing.sm,
                AppDesign.spacing.sm,
                AppDesign.spacing.md,
              ),
              child: ExpandableNutrition(
                name: usualMeal.name,
                nutrition: usualMeal.nutrition,
                expandedByDefault: expandedByDefault,
                onChanged: (nutrition) =>
                    onNutritionChanged(usualMeal.id, nutrition),
                onRemoved: () => onRemoved(usualMeal.id),
              ),
            ),
          ),
        SizedBox(height: AppDesign.spacing.sm),
        UsualMealComposer(onAdd: onAdded),
      ],
    );
  }
}
