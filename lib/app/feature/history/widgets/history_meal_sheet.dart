import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template history_meal_sheet}
/// Bottom-sheet body that surfaces the Today meal card ([MealLogSection]) for a
/// single [mealOfTheDay] on a past [day], so a forgotten meal can be added (or
/// an existing one edited) from History. Logging is stamped onto [day].
/// Rebuilds with the day log and user settings so quick picks and totals stay
/// current as meals are added.
/// {@endtemplate}
class HistoryMealSheet extends StatelessWidget {
  /// {@macro history_meal_sheet}
  const HistoryMealSheet({
    required this.mealOfTheDay,
    required this.day,
    super.key,
  });

  /// The meal this sheet logs and shows entries for.
  final MealOfTheDay mealOfTheDay;

  /// The logical day this sheet logs onto and reads entries from.
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      UserSettingsBloc,
      UserSettingsState,
      (Map<MealOfTheDay, List<UsualMeal>>, bool, TimeOfDay)
    >(
      bloc: getIt<UserSettingsBloc>(),
      selector: (state) => (
        state.usuals,
        state.expandNutritionByDefault,
        state.dayStartTime,
      ),
      builder: (context, selected) {
        final (usuals, expandNutritionByDefault, dayStart) = selected;
        return BlocSelector<DailyLogBloc, DailyLogState, List<MealLogEntry>>(
          bloc: getIt<DailyLogBloc>(),
          selector: (state) => state.mealEntries,
          builder: (context, mealEntries) {
            final breakdown = mealEntries.breakdownOn(day, dayStart);
            return TheUsualBottomSheet(
              title: MaterialLocalizations.of(context).formatMediumDate(day),
              slivers: [
                MealLogSection(
                  mealOfTheDay: mealOfTheDay,
                  mealLogEntries:
                      breakdown.entriesByMeal[mealOfTheDay] ??
                      const <MealLogEntry>[],
                  quickPicks: mealEntries.orderedQuickPicks(
                    mealOfTheDay: mealOfTheDay,
                    usuals: usuals,
                    day: day,
                    dayStart: dayStart,
                  ),
                  otherMealUsuals: mealEntries.usualsFromOtherMeals(
                    mealOfTheDay: mealOfTheDay,
                    usuals: usuals,
                    day: day,
                    dayStart: dayStart,
                  ),
                  isCurrent: false,
                  nutritionExpandedByDefault: expandNutritionByDefault,
                  day: day,
                  dayStart: dayStart,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
