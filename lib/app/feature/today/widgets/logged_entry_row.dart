import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template logged_entry_row}
/// A single logged meal entry: name, an inline-editable calories field, and a
/// remove button.
///
/// If the entry came from a usual meal that had no calories yet, editing the
/// calories here fills the usual meal's calories directly. If the usual meal
/// already had calories and the logged value now differs, a labelled button
/// appears to optionally push the new value to the usual meal.
/// {@endtemplate}
class LoggedEntryRow extends StatefulWidget {
  /// {@macro logged_entry_row}
  const LoggedEntryRow({required this.mealLogEntry, super.key});

  /// The logged entry to show.
  final MealLogEntry mealLogEntry;

  @override
  State<LoggedEntryRow> createState() => _LoggedEntryRowState();
}

class _LoggedEntryRowState extends State<LoggedEntryRow> {
  /// Whether the linked usual meal already had calories when this row first
  /// appeared. When false, editing fills the usual meal's calories directly;
  /// when true, edits offer the explicit update button instead.
  late final bool _usualMealHadCalories;

  @override
  void initState() {
    super.initState();
    final usualMeal = _linkedUsualMeal(getIt<UserSettingsBloc>().state);
    _usualMealHadCalories = usualMeal?.calories != null;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(mealLogEntry.name)),
            TheUsualTextField(
              autoSize: true,
              dense: true,
              initialValue: mealLogEntry.calories?.toString() ?? '',
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              hintText: '—',
              suffixText: ' cal',
              onChanged: (value) {
                final calories = int.tryParse(value);
                getIt<DailyLogBloc>().add(
                  DailyLogEvent.mealEntryCaloriesChanged(
                    mealLogEntry.id,
                    calories,
                  ),
                );
                // Usual meal had no calories yet: fill them in directly.
                if (!_usualMealHadCalories &&
                    mealLogEntry.usualMealId != null) {
                  getIt<UserSettingsBloc>().add(
                    UserSettingsEvent.usualMealCaloriesChanged(
                      mealLogEntry.mealOfTheDay,
                      mealLogEntry.usualMealId!,
                      calories,
                    ),
                  );
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => getIt<DailyLogBloc>().add(
                DailyLogEvent.mealEntryRemoved(mealLogEntry.id),
              ),
            ),
          ],
        ),
        if (_usualMealHadCalories)
          BlocSelector<UserSettingsBloc, UserSettingsState, UsualMeal?>(
            bloc: getIt<UserSettingsBloc>(),
            selector: _linkedUsualMeal,
            builder: (context, usualMeal) {
              final calories = mealLogEntry.calories;
              final differsFromUsualMeal =
                  usualMeal != null && usualMeal.calories != calories;

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
                    calories == null
                        ? "Clear this usual meal's calories"
                        : 'Update usual meal to $calories cal',
                  ),
                  onPressed: () => getIt<UserSettingsBloc>().add(
                    UserSettingsEvent.usualMealCaloriesChanged(
                      mealLogEntry.mealOfTheDay,
                      usualMeal.id,
                      calories,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
