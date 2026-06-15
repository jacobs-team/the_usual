import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template logged_entry_row}
/// A single logged meal entry: name, a remove button, and inline-editable
/// nutrition fields.
///
/// If the entry came from a usual meal that had no nutrition yet, editing the
/// nutrition here fills the usual meal's nutrition directly. If the usual meal
/// already had nutrition and the logged values now differ, a labelled button
/// appears to optionally push the new values to the usual meal.
/// {@endtemplate}
class LoggedEntryRow extends StatefulWidget {
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

  @override
  State<LoggedEntryRow> createState() => _LoggedEntryRowState();
}

class _LoggedEntryRowState extends State<LoggedEntryRow> {
  /// Whether the linked usual meal already had nutrition when this row first
  /// appeared. When false, editing fills the usual meal's nutrition directly;
  /// when true, edits offer the explicit update button instead.
  late final bool _usualMealHadNutrition;

  @override
  void initState() {
    super.initState();
    final usualMeal = _linkedUsualMeal(getIt<UserSettingsBloc>().state);
    _usualMealHadNutrition = usualMeal != null && !usualMeal.nutrition.isEmpty;
  }

  UsualMeal? _linkedUsualMeal(UserSettingsState state) {
    final mealLogEntry = widget.mealLogEntry;
    if (mealLogEntry.usualMealId == null) return null;
    final usualMeals =
        state.usuals[mealLogEntry.mealOfTheDay] ?? const <UsualMeal>[];
    for (final usualMeal in usualMeals) {
      if (usualMeal.id == mealLogEntry.usualMealId) return usualMeal;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final mealLogEntry = widget.mealLogEntry;
    return ExpandableNutrition(
      name: mealLogEntry.name,
      nutrition: mealLogEntry.nutrition,
      expandedByDefault: widget.expandedByDefault,
      onChanged: (nutrition) {
        getIt<DailyLogBloc>().add(
          DailyLogEvent.mealEntryNutritionChanged(mealLogEntry.id, nutrition),
        );
        // Usual meal had no nutrition yet: fill it in directly.
        if (!_usualMealHadNutrition && mealLogEntry.usualMealId != null) {
          getIt<UserSettingsBloc>().add(
            UserSettingsEvent.usualMealNutritionChanged(
              mealLogEntry.mealOfTheDay,
              mealLogEntry.usualMealId!,
              nutrition,
            ),
          );
        }
      },
      onRemoved: () => getIt<DailyLogBloc>().add(
        DailyLogEvent.mealEntryRemoved(mealLogEntry.id),
      ),
      expandedFooter: _usualMealHadNutrition
          ? BlocSelector<UserSettingsBloc, UserSettingsState, UsualMeal?>(
              bloc: getIt<UserSettingsBloc>(),
              selector: _linkedUsualMeal,
              builder: (context, usualMeal) {
                final nutrition = mealLogEntry.nutrition;
                final differsFromUsualMeal =
                    usualMeal != null && usualMeal.nutrition != nutrition;

                if (!differsFromUsualMeal) return const SizedBox.shrink();
                return Align(
                  alignment: Alignment.centerLeft,
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
                );
              },
            )
          : null,
    );
  }
}
