import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template meal_log_section}
/// One meal's slice of the Today view: what's been logged for it so far,
/// quick-pick chips for the user's usuals not yet logged, and an entry point
/// for logging something off-menu.
/// {@endtemplate}
class MealLogSection extends StatelessWidget {
  /// {@macro meal_log_section}
  const MealLogSection({
    required this.mealOfTheDay,
    required this.mealLogEntries,
    required this.usualMeals,
    required this.isCurrent,
    required this.nutritionExpandedByDefault,
    super.key,
  });

  /// The meal this section represents.
  final MealOfTheDay mealOfTheDay;

  /// Entries already logged for this meal today.
  final List<MealLogEntry> mealLogEntries;

  /// The user's usual meals for this meal.
  final List<UsualMeal> usualMeals;

  /// Whether this is the meal nearest the current time.
  final bool isCurrent;

  /// Whether each logged entry's nutrition fields start expanded for editing.
  final bool nutritionExpandedByDefault;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nutrition = mealLogEntries.totalNutrition;
    final loggedNames = mealLogEntries
        .map((mealLogEntry) => mealLogEntry.name.toLowerCase())
        .toSet();
    // TODO(today): order quick picks with the most recently logged usual meal
    // first, then by how often each has been logged. Compute this from log
    // history in the bloc/state, not here — it shouldn't recompute on every
    // build.
    final quickPicks = usualMeals
        .where(
          (usualMeal) => !loggedNames.contains(usualMeal.name.toLowerCase()),
        )
        .toList();

    return Card(
      margin: EdgeInsets.only(bottom: AppDesign.spacing.md),
      shape: isCurrent
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDesign.radius.sm),
              side: BorderSide(color: theme.colorScheme.primary, width: 2),
            )
          : null,
      child: Padding(
        padding: EdgeInsets.all(AppDesign.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    mealOfTheDay.label,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                if (mealLogEntries.isNotEmpty)
                  Text(
                    nutrition.summary,
                    style: theme.textTheme.bodyMedium,
                  ),
              ],
            ),
            SizedBox(height: AppDesign.spacing.sm),
            for (final mealLogEntry in mealLogEntries)
              LoggedEntryRow(
                key: ValueKey(mealLogEntry.id),
                mealLogEntry: mealLogEntry,
                expandedByDefault: nutritionExpandedByDefault,
              ),
            if (quickPicks.isNotEmpty) ...[
              SizedBox(height: AppDesign.spacing.sm),
              Wrap(
                spacing: AppDesign.spacing.sm,
                runSpacing: AppDesign.spacing.sm,
                children: [
                  for (final usualMeal in quickPicks)
                    ActionChip(
                      label: Text('+ ${usualMeal.name}'),
                      onPressed: () => getIt<DailyLogBloc>().add(
                        DailyLogEvent.mealLogged(
                          mealOfTheDay,
                          usualMeal.name,
                          nutrition: usualMeal.nutrition,
                          usualMealId: usualMeal.id,
                          photoPath: usualMeal.photoPath,
                        ),
                      ),
                    ),
                ],
              ),
            ],
            SizedBox(height: AppDesign.spacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () async {
                  final result =
                      await showModalBottomSheet<
                        (String, Nutrition, int, bool)
                      >(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => const FoodEntrySheet(
                          title: 'Log something else',
                          confirmLabel: 'Log',
                          showAddToUsualMeals: true,
                        ),
                      );
                  if (result == null) return;
                  final (name, nutrition, quantity, addToUsualMeals) = result;
                  if (addToUsualMeals) {
                    getIt<UserSettingsBloc>().add(
                      UserSettingsEvent.usualMealAdded(
                        mealOfTheDay,
                        name,
                        nutrition,
                      ),
                    );
                  }
                  getIt<DailyLogBloc>().add(
                    DailyLogEvent.mealLogged(
                      mealOfTheDay,
                      name,
                      nutrition: nutrition,
                      quantity: quantity,
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('I ate something else'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
