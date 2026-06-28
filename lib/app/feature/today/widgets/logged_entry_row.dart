import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

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
    final usualMealId = mealLogEntry.usualMealId;
    if (usualMealId == null) return null;
    final usualMeals =
        state.usuals[mealLogEntry.mealOfTheDay] ?? const <UsualMeal>[];
    for (final usualMeal in usualMeals) {
      if (usualMeal.id == usualMealId) return usualMeal;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<UserSettingsBloc, UserSettingsState, UsualMeal?>(
      bloc: getIt<UserSettingsBloc>(),
      selector: _linkedUsualMeal,
      builder: (context, usualMeal) {
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
          expandedFooter: usualMeal == null
              ? UpdateUsualButton(
                  label: 'Save as usual',
                  onPressed: () {
                    final usualMealId = getIt<UserSettingsBloc>()
                        .saveAsUsualMeal(
                          mealLogEntry.mealOfTheDay,
                          mealLogEntry.name,
                          nutrition,
                        );
                    getIt<DailyLogBloc>().add(
                      DailyLogEvent.mealEntryUsualMealLinked(
                        mealLogEntry.id,
                        usualMealId,
                      ),
                    );
                  },
                )
              : differsFromUsualMeal
              ? UpdateUsualButton(
                  label: nutrition.isEmpty
                      ? "Clear this usual meal's nutrition"
                      : 'Update usual meal to match',
                  onPressed: () => getIt<UserSettingsBloc>().add(
                    UserSettingsEvent.usualMealNutritionChanged(
                      mealLogEntry.mealOfTheDay,
                      usualMeal.id,
                      nutrition,
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}
