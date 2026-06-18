import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template usual_meal_section}
/// One meal's usual meals: a heading and the saved meals as editable rows,
/// optionally followed by inline controls to add a new one. The add controls
/// show when [showAddControls] is set, as in onboarding; the settings view
/// hides them and adds through its own action.
/// {@endtemplate}
class UsualMealSection extends StatelessWidget {
  /// {@macro usual_meal_section}
  const UsualMealSection({
    required this.mealOfTheDay,
    required this.usualMeals,
    required this.expandedByDefault,
    required this.onNutritionChanged,
    required this.onNameChanged,
    required this.onRemoved,
    this.onAdded,
    this.showHeader = true,
    this.showAddControls = true,
    super.key,
  }) : assert(
         !showAddControls || onAdded != null,
         'onAdded is required when showAddControls is true.',
       );

  /// The meal this section represents.
  final MealOfTheDay mealOfTheDay;

  /// The saved usual meals for this meal.
  final List<UsualMeal> usualMeals;

  /// Whether each meal's nutrition fields start expanded for editing.
  final bool expandedByDefault;

  /// Whether to show the meal-name header. Hidden where the surrounding UI
  /// already names the meal, e.g. the settings tab bar.
  final bool showHeader;

  /// Whether to show the inline add controls (the composer and the AI entry
  /// button). Hidden where the surrounding UI provides its own add action.
  final bool showAddControls;

  /// Called with the name and nutrition of a new usual meal. Required when
  /// [showAddControls] is set.
  final void Function(String name, Nutrition nutrition)? onAdded;

  /// Called with a usual meal's id and its new nutrition.
  final void Function(String id, Nutrition nutrition) onNutritionChanged;

  /// Called with a usual meal's id and its new name.
  final void Function(String id, String name) onNameChanged;

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
                AppDesign.spacing.md,
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
                onNameChanged: (name) => onNameChanged(usualMeal.id, name),
                onRemoved: () => onRemoved(usualMeal.id),
              ),
            ),
          ),
        if (showAddControls) ...[
          SizedBox(height: AppDesign.spacing.sm),
          if (getIt<MealAiRepository>().isConfigured) ...[
            FilledButton.tonalIcon(
              onPressed: () async {
                final results =
                    await showModalBottomSheet<List<FoodEntryResult>>(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      showDragHandle: false,
                      enableDrag: false,
                      isDismissible: false,
                      builder: (context) => const FoodEntrySheet(
                        title: 'Add usual meals',
                        confirmLabel: 'Add',
                        showQuantity: false,
                      ),
                    );
                if (results == null) return;
                for (final result in results) {
                  onAdded!(result.name, result.nutrition);
                }
              },
              icon: const Icon(Icons.auto_awesome_outlined),
              label: const Text('Add with a photo or description'),
            ),
            SizedBox(height: AppDesign.spacing.sm),
          ],
          UsualMealComposer(onAdd: onAdded!),
        ],
      ],
    );
  }
}
