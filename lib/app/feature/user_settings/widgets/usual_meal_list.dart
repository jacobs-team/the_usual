import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template usual_meal_list}
/// One meal's tab on the usual meals screen: the saved usual meals, edited in
/// place. New meals are added through the screen's floating action button. Kept
/// alive so swiping between tabs doesn't rebuild its fields.
/// {@endtemplate}
class UsualMealList extends StatefulWidget {
  /// {@macro usual_meal_list}
  const UsualMealList({required this.mealOfTheDay, super.key});

  /// The meal group this list shows.
  final MealOfTheDay mealOfTheDay;

  @override
  State<UsualMealList> createState() => _UsualMealListState();
}

class _UsualMealListState extends State<UsualMealList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final mealOfTheDay = widget.mealOfTheDay;
    return BlocSelector<
      UserSettingsBloc,
      UserSettingsState,
      (List<UsualMeal>, bool)
    >(
      bloc: getIt<UserSettingsBloc>(),
      selector: (state) => (
        state.usuals[mealOfTheDay] ?? <UsualMeal>[],
        state.expandNutritionByDefault,
      ),
      builder: (context, selected) {
        final (usualMeals, expandNutritionByDefault) = selected;
        return ListView(
          padding: EdgeInsets.all(AppDesign.spacing.lg),
          children: [
            if (usualMeals.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppDesign.spacing.xxl),
                child: Text(
                  'No usual ${mealOfTheDay.label.toLowerCase()} meals yet.\n'
                  'Tap the + button to add one.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              UsualMealSection(
                mealOfTheDay: mealOfTheDay,
                usualMeals: usualMeals,
                expandedByDefault: expandNutritionByDefault,
                showHeader: false,
                showAddControls: false,
                onNutritionChanged: (id, nutrition) =>
                    getIt<UserSettingsBloc>().add(
                      UserSettingsEvent.usualMealNutritionChanged(
                        mealOfTheDay,
                        id,
                        nutrition,
                      ),
                    ),
                onNameChanged: (id, name) => getIt<UserSettingsBloc>().add(
                  UserSettingsEvent.usualMealNameChanged(
                    mealOfTheDay,
                    id,
                    name,
                  ),
                ),
                onRemoved: (id) => getIt<UserSettingsBloc>().add(
                  UserSettingsEvent.usualMealRemoved(mealOfTheDay, id),
                ),
              ),
            // Clears the floating action button so the last card isn't hidden
            // behind it.
            const SizedBox(height: kFloatingActionButtonMargin + 56),
          ],
        );
      },
    );
  }
}
