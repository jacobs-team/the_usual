import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final calories = mealLogEntries.fold(
      0,
      (total, mealLogEntry) => total + (mealLogEntry.calories ?? 0),
    );
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
      margin: const EdgeInsets.only(bottom: 12),
      shape: isCurrent
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.colorScheme.primary, width: 2),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                  Text('$calories cal', style: theme.textTheme.bodyMedium),
              ],
            ),
            for (final mealLogEntry in mealLogEntries)
              LoggedEntryRow(
                key: ValueKey(mealLogEntry.id),
                mealLogEntry: mealLogEntry,
              ),
            if (quickPicks.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final usualMeal in quickPicks)
                    ActionChip(
                      label: Text('+ ${usualMeal.name}'),
                      onPressed: () => getIt<DailyLogBloc>().add(
                        DailyLogEvent.mealLogged(
                          mealOfTheDay,
                          usualMeal.name,
                          calories: usualMeal.calories,
                          usualMealId: usualMeal.id,
                          photoPath: usualMeal.photoPath,
                        ),
                      ),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () async {
                  final result =
                      await showModalBottomSheet<(String, int?, bool)>(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => const FoodEntrySheet(
                          title: 'Log something else',
                          confirmLabel: 'Log',
                          showAddToUsualMeals: true,
                        ),
                      );
                  if (result == null) return;
                  final (name, calories, addToUsualMeals) = result;
                  if (addToUsualMeals) {
                    getIt<UserSettingsBloc>().add(
                      UserSettingsEvent.usualMealAdded(
                        mealOfTheDay,
                        name,
                        calories,
                      ),
                    );
                  }
                  getIt<DailyLogBloc>().add(
                    DailyLogEvent.mealLogged(
                      mealOfTheDay,
                      name,
                      calories: calories,
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
