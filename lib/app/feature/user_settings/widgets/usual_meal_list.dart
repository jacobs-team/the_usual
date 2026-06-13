import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template usual_meal_list}
/// One meal's tab on the usual meals screen: the saved usual meals with an
/// inline composer to add more.
/// {@endtemplate}
class UsualMealList extends StatelessWidget {
  /// {@macro usual_meal_list}
  const UsualMealList({required this.mealOfTheDay, super.key});

  /// The meal group this list shows.
  final MealOfTheDay mealOfTheDay;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<UserSettingsBloc, UserSettingsState, List<UsualMeal>>(
      bloc: getIt<UserSettingsBloc>(),
      selector: (state) => state.usuals[mealOfTheDay] ?? <UsualMeal>[],
      builder: (context, usualMeals) {
        return ListView(
          padding: EdgeInsets.all(AppDesign.spacing.lg),
          children: [
            UsualMealSection(
              mealOfTheDay: mealOfTheDay,
              usualMeals: usualMeals,
              onAdded: (name, calories) => getIt<UserSettingsBloc>().add(
                UserSettingsEvent.usualMealAdded(mealOfTheDay, name, calories),
              ),
              onCaloriesChanged: (id, calories) =>
                  getIt<UserSettingsBloc>().add(
                    UserSettingsEvent.usualMealCaloriesChanged(
                      mealOfTheDay,
                      id,
                      calories,
                    ),
                  ),
              onRemoved: (id) => getIt<UserSettingsBloc>().add(
                UserSettingsEvent.usualMealRemoved(mealOfTheDay, id),
              ),
            ),
          ],
        );
      },
    );
  }
}
