import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template usual_meals_view}
/// Manages the user's usuals library: one tab per meal with the saved items,
/// editable calories, and an inline composer to add more.
/// {@endtemplate}
class UsualMealsView extends StatelessWidget {
  /// {@macro usual_meals_view}
  const UsualMealsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: MealOfTheDay.values.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Your usual meals'),
          leading: BackButton(onPressed: () => context.go(Routes.settings)),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              for (final mealOfTheDay in MealOfTheDay.values)
                BlocSelector<UserSettingsBloc, UserSettingsState, int>(
                  bloc: getIt<UserSettingsBloc>(),
                  selector: (state) => state.usuals[mealOfTheDay]?.length ?? 0,
                  builder: (context, count) {
                    return Tab(text: '${mealOfTheDay.label} ($count)');
                  },
                ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            for (final mealOfTheDay in MealOfTheDay.values)
              UsualMealList(mealOfTheDay: mealOfTheDay),
          ],
        ),
      ),
    );
  }
}
