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
    this.logDays,
    this.dayStart,
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

  /// The days meals logged from this section are recorded onto. Null logs to
  /// today (stamped at the current time); a single-element list logs to one
  /// day (the History view), and a multi-day list bulk-logs the same entry
  /// onto every day in the range.
  final List<DateTime>? logDays;

  /// The user's day-start, used with [logDays] to stamp entries onto each day.
  final TimeOfDay? dayStart;

  /// Logs [name] under [mealOfTheDay] onto every day in [logDays], or to today
  /// when [logDays] is null.
  void _logOntoTargetDays(
    MealOfTheDay mealOfTheDay,
    String name, {
    Nutrition nutrition = const Nutrition(),
    double quantity = 1,
    String? usualMealId,
    String? photoPath,
  }) {
    final targetDays = logDays;
    final dailyLogBloc = getIt<DailyLogBloc>();
    if (targetDays == null) {
      dailyLogBloc.add(
        DailyLogEvent.mealLogged(
          mealOfTheDay,
          name,
          nutrition: nutrition,
          quantity: quantity,
          usualMealId: usualMealId,
          photoPath: photoPath,
        ),
      );
      return;
    }
    for (final day in targetDays) {
      dailyLogBloc.add(
        DailyLogEvent.mealLogged(
          mealOfTheDay,
          name,
          nutrition: nutrition,
          quantity: quantity,
          usualMealId: usualMealId,
          photoPath: photoPath,
          day: day,
          dayStart: dayStart,
        ),
      );
    }
  }

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
          padding: EdgeInsets.all(AppDesign.spacing.md),
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
                      Wrap(
                        spacing: AppDesign.spacing.sm,
                        runSpacing: AppDesign.spacing.sm,
                        children: [
                          for (final usualMeal in quickPicks)
                            _QuickPickChip(
                              label: '+ ${usualMeal.name}',
                              onPressed: () => _logOntoTargetDays(
                                mealOfTheDay,
                                usualMeal.name,
                                nutrition: usualMeal.nutrition,
                                usualMealId: usualMeal.id,
                                photoPath: usualMeal.photoPath,
                              ),
                              onRemove: () => getIt<UserSettingsBloc>().add(
                                UserSettingsEvent.usualMealRemoved(
                                  mealOfTheDay,
                                  usualMeal.id,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                    SizedBox(height: AppDesign.spacing.sm),
                    Wrap(
                      spacing: AppDesign.spacing.sm,
                      children: [
                        TextButton.icon(
                          onPressed: () async {
                            final result =
                                await TheUsualBottomSheet.show<
                                  FoodEntrySheetResult
                                >(
                                  context,
                                  builder: (context) => const FoodEntrySheet(
                                    title: 'Log something else',
                                    confirmLabel: 'Log',
                                    showAddToUsualMeals: true,
                                  ),
                                );
                            if (result == null) return;
                            for (final foodResult in result.foods) {
                              if (foodResult.addToUsualMeals) {
                                getIt<UserSettingsBloc>().add(
                                  UserSettingsEvent.usualMealAdded(
                                    mealOfTheDay,
                                    foodResult.name,
                                    foodResult.nutrition,
                                  ),
                                );
                              }
                              _logOntoTargetDays(
                                mealOfTheDay,
                                foodResult.name,
                                nutrition: foodResult.nutrition,
                                quantity: foodResult.quantity,
                              );
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Something else'),
                        ),
                        if (otherMealUsuals.isNotEmpty)
                          TextButton.icon(
                            onPressed: () => TheUsualBottomSheet.show<void>(
                              context,
                              builder: (_) => OtherMealUsualsSheet(
                                mealOfTheDay: mealOfTheDay,
                                usualsByMeal: otherMealUsuals,
                                logDays: logDays,
                                dayStart: dayStart,
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

/// A quick pick for a usual meal not yet logged: a dashed border and a muted
/// fill mark it as available to add rather than already on the day. Tapping
/// logs it; a long press opens a menu to remove it from the user's usuals.
class _QuickPickChip extends StatelessWidget {
  const _QuickPickChip({
    required this.label,
    required this.onPressed,
    required this.onRemove,
  });

  final String label;
  final VoidCallback onPressed;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(AppDesign.radius.lg);

    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(Icons.delete_outline),
          onPressed: onRemove,
          child: const Text('Remove from usuals'),
        ),
      ],
      builder: (context, controller, child) {
        return DashedBorder(
          color: theme.colorScheme.outlineVariant,
          radius: AppDesign.radius.lg,
          child: Material(
            borderRadius: borderRadius,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              onLongPress: controller.open,
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
      },
    );
  }
}
