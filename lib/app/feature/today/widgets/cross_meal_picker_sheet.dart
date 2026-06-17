import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template other_meal_usuals_sheet}
/// Bottom sheet for logging a usual that belongs to another meal into the
/// current one. Lists [usualsByMeal] grouped by their own meal; tapping a usual
/// logs it under [mealOfTheDay] and closes the sheet.
/// {@endtemplate}
class OtherMealUsualsSheet extends StatelessWidget {
  /// {@macro other_meal_usuals_sheet}
  const OtherMealUsualsSheet({
    required this.mealOfTheDay,
    required this.usualsByMeal,
    super.key,
  });

  /// The meal a tapped usual is logged under.
  final MealOfTheDay mealOfTheDay;

  /// Usuals from other meals, grouped by their own meal.
  final Map<MealOfTheDay, List<UsualMeal>> usualsByMeal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppDesign.spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Log to ${mealOfTheDay.label}',
              style: theme.textTheme.titleMedium,
            ),
            for (final group in usualsByMeal.entries) ...[
              SizedBox(height: AppDesign.spacing.md),
              Text(
                group.key.label.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              for (final usualMeal in group.value)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(usualMeal.name),
                  subtitle: usualMeal.nutrition.isEmpty
                      ? null
                      : Text(usualMeal.nutrition.summary),
                  trailing: const Icon(Icons.add),
                  onTap: () {
                    getIt<DailyLogBloc>().add(
                      DailyLogEvent.mealLogged(
                        mealOfTheDay,
                        usualMeal.name,
                        nutrition: usualMeal.nutrition,
                        usualMealId: usualMeal.id,
                        photoPath: usualMeal.photoPath,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                ),
            ],
          ],
        ),
      ),
    );
  }
}
