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
    this.day,
    this.dayStart,
    super.key,
  });

  /// The meal a tapped usual is logged under.
  final MealOfTheDay mealOfTheDay;

  /// Usuals from other meals, grouped by their own meal.
  final Map<MealOfTheDay, List<UsualMeal>> usualsByMeal;

  /// The day a tapped usual is logged onto. Null logs to today.
  final DateTime? day;

  /// The user's day-start, used with [day] to stamp the entry onto that day.
  final TimeOfDay? dayStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return TheUsualBottomSheet(
      title: 'Log to ${mealOfTheDay.label}',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final group in usualsByMeal.entries) ...[
            if (group.key != usualsByMeal.entries.first.key)
              SizedBox(height: AppDesign.spacing.md),
            Text(
              group.key.label.toUpperCase(),
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            for (final usualMeal in group.value) ...[
              SizedBox(height: AppDesign.spacing.sm),
              Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    getIt<DailyLogBloc>().add(
                      DailyLogEvent.mealLogged(
                        mealOfTheDay,
                        usualMeal.name,
                        nutrition: usualMeal.nutrition,
                        usualMealId: usualMeal.id,
                        photoPath: usualMeal.photoPath,
                        day: day,
                        dayStart: dayStart,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(AppDesign.spacing.md),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                usualMeal.name,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (!usualMeal.nutrition.isEmpty) ...[
                                SizedBox(height: AppDesign.spacing.xs),
                                DefaultTextStyle.merge(
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  child: NutritionSummary(
                                    usualMeal.nutrition,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(width: AppDesign.spacing.md),
                        Icon(Icons.add, color: colorScheme.onSurfaceVariant),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
