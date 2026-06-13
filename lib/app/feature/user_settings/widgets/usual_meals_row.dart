import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template usual_meals_row}
/// Settings row summarizing the usuals library, navigating to the usual
/// meals screen.
/// {@endtemplate}
class UsualMealsRow extends StatelessWidget {
  /// {@macro usual_meals_row}
  const UsualMealsRow({super.key});

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
          (sum, meal) => sum + (usuals[meal]?.length ?? 0),
        );
        final summary = [
          '$total items',
          for (final meal in MealOfTheDay.values)
            '${meal.label} ${usuals[meal]?.length ?? 0}',
        ].join(' · ');
        return Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            title: const Text('Your usual meals'),
            subtitle: Text(summary),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(Routes.usualMeals),
          ),
        );
      },
    );
  }
}
