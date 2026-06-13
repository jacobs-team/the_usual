import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template usual_meals_tile}
/// Settings tile summarizing the usuals library, navigating to the usual
/// meals screen.
/// {@endtemplate}
class UsualMealsTile extends StatelessWidget {
  /// {@macro usual_meals_tile}
  const UsualMealsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      UserSettingsBloc,
      UserSettingsState,
      Map<MealOfTheDay, List<UsualMeal>>
    >(
      bloc: getIt<UserSettingsBloc>(),
      selector: (state) => state.usuals,
      builder: (context, usuals) {
        final total = MealOfTheDay.values.fold(
          0,
          (sum, mealOfTheDay) => sum + (usuals[mealOfTheDay]?.length ?? 0),
        );
        final summary = [
          '$total items',
          for (final mealOfTheDay in MealOfTheDay.values)
            '${mealOfTheDay.label} ${usuals[mealOfTheDay]?.length ?? 0}',
        ].join(' · ');
        return SettingsNavRow(
          title: 'Your usual meals',
          subtitle: summary,
          onTap: () => context.go(Routes.usualMeals),
        );
      },
    );
  }
}
