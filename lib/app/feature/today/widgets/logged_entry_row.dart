import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template logged_entry_row}
/// A single logged meal entry: name, a remove button, and inline-editable
/// nutrition fields.
///
/// When linked to a usual meal the row shows that usual meal's current name, so
/// renaming it in settings is reflected here. When the logged nutrition differs
/// from the usual meal, a labelled button appears to push the logged values to
/// it.
/// {@endtemplate}
class LoggedEntryRow extends StatelessWidget {
  /// {@macro logged_entry_row}
  const LoggedEntryRow({
    required this.mealLogEntry,
    required this.expandedByDefault,
    super.key,
  });

  /// The logged entry to show.
  final MealLogEntry mealLogEntry;

  /// Whether the nutrition fields start expanded for editing.
  final bool expandedByDefault;

  UsualMeal? _linkedUsualMeal(UserSettingsState state) {
    final usualMeals =
        state.usuals[mealLogEntry.mealOfTheDay] ?? const <UsualMeal>[];
    for (final usualMeal in usualMeals) {
      if (usualMeal.id == mealLogEntry.usualMealId ||
          usualMeal.name.toLowerCase() == mealLogEntry.name.toLowerCase()) {
        return usualMeal;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<UserSettingsBloc, UserSettingsState, UsualMeal?>(
      bloc: getIt<UserSettingsBloc>(),
      selector: _linkedUsualMeal,
      builder: (context, usualMeal) {
        // When linked only by name (the stored id is stale or absent), stamp
        // the usual meal's current id onto the entry so the link survives a
        // later rename. Deferred to after the frame to keep build pure.

        // TODO: fix this trash later.
        if (usualMeal != null && usualMeal.id != mealLogEntry.usualMealId) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            getIt<DailyLogBloc>().add(
              DailyLogEvent.mealEntryUsualMealLinked(
                mealLogEntry.id,
                usualMeal.id,
              ),
            );
          });
        }

        final nutrition = mealLogEntry.nutrition;
        final differsFromUsualMeal =
            usualMeal != null && usualMeal.nutrition != nutrition;

        return ExpandableNutrition(
          name: usualMeal?.name ?? mealLogEntry.name,
          nutrition: nutrition,
          quantity: mealLogEntry.quantity,
          onQuantityChanged: (quantity) => getIt<DailyLogBloc>().add(
            DailyLogEvent.mealEntryQuantityChanged(mealLogEntry.id, quantity),
          ),
          expandedByDefault: expandedByDefault,
          onChanged: (nutrition) => getIt<DailyLogBloc>().add(
            DailyLogEvent.mealEntryNutritionChanged(mealLogEntry.id, nutrition),
          ),
          onRemoved: () => getIt<DailyLogBloc>().add(
            DailyLogEvent.mealEntryRemoved(mealLogEntry.id),
          ),
          expandedFooter: differsFromUsualMeal
              ? Padding(
                  padding: EdgeInsets.only(
                    left: AppDesign.spacing.sm,
                    top: AppDesign.spacing.sm,
                  ),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: const Icon(Icons.sync, size: 16),
                    label: Text(
                      nutrition.isEmpty
                          ? "Clear this usual meal's nutrition"
                          : 'Update usual meal to match',
                    ),
                    onPressed: () => getIt<UserSettingsBloc>().add(
                      UserSettingsEvent.usualMealNutritionChanged(
                        mealLogEntry.mealOfTheDay,
                        usualMeal.id,
                        nutrition,
                      ),
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}
