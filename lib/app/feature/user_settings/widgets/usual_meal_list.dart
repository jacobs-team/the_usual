import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template usual_meal_list}
/// One meal's tab on the usual meals screen: the saved usual meals with an
/// inline composer to add more. Kept alive so swiping between tabs doesn't
/// rebuild its fields.
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
              onAdded: (name, nutrition) => getIt<UserSettingsBloc>().add(
                UserSettingsEvent.usualMealAdded(mealOfTheDay, name, nutrition),
              ),
              onNutritionChanged: (id, nutrition) =>
                  getIt<UserSettingsBloc>().add(
                    UserSettingsEvent.usualMealNutritionChanged(
                      mealOfTheDay,
                      id,
                      nutrition,
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
