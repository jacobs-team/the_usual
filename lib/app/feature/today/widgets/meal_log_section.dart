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
    required this.quickPicks,
    required this.otherMealUsuals,
    required this.isCurrent,
    required this.nutritionExpandedByDefault,
    super.key,
  });

  /// The meal this section represents.
  final MealOfTheDay mealOfTheDay;

  /// Entries already logged for this meal today.
  final List<MealLogEntry> mealLogEntries;

  /// The user's usuals offered as quick picks for this meal, already filtered
  /// and ordered (most recent, then most logged here).
  final List<UsualMeal> quickPicks;

  /// Usuals from other meals, grouped by their own meal, for the "from another
  /// meal" picker. Empty when there are none to cross-post.
  final Map<MealOfTheDay, List<UsualMeal>> otherMealUsuals;

  /// Whether this is the meal nearest the current time.
  final bool isCurrent;

  /// Whether each logged entry's nutrition fields start expanded for editing.
  final bool nutritionExpandedByDefault;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nutrition = mealLogEntries.totalNutrition;

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
                        DefaultTextStyle.merge(
                          style: theme.textTheme.bodyMedium,
                          child: NutritionSummary(nutrition),
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
                      _QuickPickColumns(
                        mealOfTheDay: mealOfTheDay,
                        quickPicks: quickPicks,
                      ),
                    ],
                    SizedBox(height: AppDesign.spacing.sm),
                    Wrap(
                      spacing: AppDesign.spacing.sm,
                      children: [
                        TextButton.icon(
                          onPressed: () async {
                            final results =
                                await showModalBottomSheet<
                                  List<FoodEntryResult>
                                >(
                                  context: context,
                                  isScrollControlled: true,
                                  useSafeArea: true,
                                  showDragHandle: true,
                                  builder: (context) => const FoodEntrySheet(
                                    title: 'Log something else',
                                    confirmLabel: 'Log',
                                    showAddToUsualMeals: true,
                                  ),
                                );
                            if (results == null) return;
                            for (final result in results) {
                              if (result.addToUsualMeals) {
                                getIt<UserSettingsBloc>().add(
                                  UserSettingsEvent.usualMealAdded(
                                    mealOfTheDay,
                                    result.name,
                                    result.nutrition,
                                  ),
                                );
                              }
                              getIt<DailyLogBloc>().add(
                                DailyLogEvent.mealLogged(
                                  mealOfTheDay,
                                  result.name,
                                  nutrition: result.nutrition,
                                  quantity: result.quantity,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('I ate something else'),
                        ),
                        if (otherMealUsuals.isNotEmpty)
                          TextButton.icon(
                            onPressed: () => showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: true,
                              showDragHandle: true,
                              builder: (_) => OtherMealUsualsSheet(
                                mealOfTheDay: mealOfTheDay,
                                usualsByMeal: otherMealUsuals,
                              ),
                            ),
                            icon: const Icon(Icons.restaurant_menu),
                            label: const Text('From another meal'),
                          ),
                      ],
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

/// Lays the quick picks into columns of up to three chips, filling top to
/// bottom then spilling rightward in a horizontal scroll view. Tapping a chip
/// logs that usual under [mealOfTheDay].
class _QuickPickColumns extends StatelessWidget {
  const _QuickPickColumns({
    required this.mealOfTheDay,
    required this.quickPicks,
  });

  /// The meal a tapped chip logs under.
  final MealOfTheDay mealOfTheDay;

  /// The usuals to offer, already filtered and ordered.
  final List<UsualMeal> quickPicks;

  static const _rowsPerColumn = 3;

  @override
  Widget build(BuildContext context) {
    final columns = <List<UsualMeal>>[];
    for (var start = 0; start < quickPicks.length; start += _rowsPerColumn) {
      final end = (start + _rowsPerColumn).clamp(0, quickPicks.length);
      columns.add(quickPicks.sublist(start, end));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (columnIndex, column) in columns.indexed) ...[
            if (columnIndex > 0) SizedBox(width: AppDesign.spacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final (rowIndex, usualMeal) in column.indexed) ...[
                  if (rowIndex > 0) SizedBox(height: AppDesign.spacing.sm),
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
              ],
            ),
          ],
        ],
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
