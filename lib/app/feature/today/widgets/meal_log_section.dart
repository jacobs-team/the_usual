import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template meal_log_section}
/// One meal's slice of the Today view: what's been logged for it so far,
/// quick-pick chips for the user's usuals not yet logged, and an entry point
/// for logging something off-menu. Builds as a sliver for a [CustomScrollView].
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
    final loggedUsualMealIds = mealLogEntries
        .map((mealLogEntry) => mealLogEntry.usualMealId)
        .whereType<String>()
        .toSet();
    // TODO(today): order quick picks with the most recently logged usual meal
    // first, then by how often each has been logged. Compute this from log
    // history in the bloc/state, not here — it shouldn't recompute on every
    // build.
    final quickPicks = usualMeals.where((usualMeal) {
      // A logged entry keeps its original name, so after a rename match on the
      // linked id too, otherwise the renamed usual reappears as a quick pick.
      final alreadyLoggedByName = loggedNames.contains(
        usualMeal.name.toLowerCase(),
      );
      final alreadyLoggedById = loggedUsualMealIds.contains(usualMeal.id);
      return !alreadyLoggedByName && !alreadyLoggedById;
    }).toList();

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        AppDesign.spacing.lg,
        0,
        AppDesign.spacing.lg,
        AppDesign.spacing.md,
      ),
      sliver: DecoratedSliver(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(
            isCurrent ? AppDesign.radius.sm : AppDesign.radius.md,
          ),
          border: Border.all(
            color: isCurrent
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: isCurrent ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        sliver: SliverPadding(
          padding: EdgeInsets.all(AppDesign.spacing.lg),
          sliver: SliverMainAxisGroup(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: AppDesign.spacing.sm),
                  child: Row(
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
                ),
              ),
              SliverList.builder(
                itemCount: mealLogEntries.length,
                itemBuilder: (context, index) {
                  final mealLogEntry = mealLogEntries[index];
                  return LoggedEntryRow(
                    key: ValueKey(mealLogEntry.id),
                    mealLogEntry: mealLogEntry,
                    expandedByDefault: nutritionExpandedByDefault,
                  );
                },
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (quickPicks.isNotEmpty) ...[
                      SizedBox(height: AppDesign.spacing.md),
                      Wrap(
                        spacing: AppDesign.spacing.sm,
                        runSpacing: AppDesign.spacing.sm,
                        children: [
                          for (final usualMeal in quickPicks)
                            _QuickPickChip(
                              label: '+ ${usualMeal.name}',
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
                          final (name, nutrition, quantity, addToUsualMeals) =
                              result;
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
            ],
          ),
        ),
      ),
    );
  }
}

/// A quick pick for a usual meal not yet logged: a dashed border and a muted
/// fill mark it as available to add rather than already on the day.
class _QuickPickChip extends StatelessWidget {
  const _QuickPickChip({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(AppDesign.radius.lg);

    return DashedBorder(
      color: theme.colorScheme.outlineVariant,
      radius: AppDesign.radius.lg,
      child: Material(
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDesign.spacing.md,
              vertical: AppDesign.spacing.sm,
            ),
            child: Text(label, style: theme.textTheme.labelLarge),
          ),
        ),
      ),
    );
  }
}
