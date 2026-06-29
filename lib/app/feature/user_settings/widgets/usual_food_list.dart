import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template usual_food_list}
/// The usual foods library: one editable card per food. New foods are added
/// through the screen's floating action button.
/// {@endtemplate}
class UsualFoodList extends StatelessWidget {
  /// {@macro usual_food_list}
  const UsualFoodList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      UserSettingsBloc,
      UserSettingsState,
      (List<UsualFood>, bool)
    >(
      bloc: getIt<UserSettingsBloc>(),
      selector: (state) => (state.usualFoods, state.expandNutritionByDefault),
      builder: (context, selected) {
        final (usualFoods, expandNutritionByDefault) = selected;
        if (usualFoods.isEmpty) {
          return const Center(
            child: Text(
              'No usual foods yet. Tap + to add one.',
              key: Key('usualFoodsEmpty'),
              textAlign: TextAlign.center,
            ),
          );
        }
        return ListView(
          padding: EdgeInsets.all(AppDesign.spacing.lg),
          children: [
            for (final usualFood in usualFoods)
              Card(
                key: ValueKey(usualFood.id),
                margin: EdgeInsets.only(bottom: AppDesign.spacing.sm),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppDesign.spacing.md,
                    AppDesign.spacing.sm,
                    AppDesign.spacing.sm,
                    AppDesign.spacing.md,
                  ),
                  child: ExpandableNutrition(
                    name: usualFood.name,
                    nutrition: usualFood.nutrition,
                    expandedByDefault: expandNutritionByDefault,
                    onNameChanged: (name) => getIt<UserSettingsBloc>().add(
                      UserSettingsEvent.usualFoodNameChanged(
                        usualFood.id,
                        name,
                      ),
                    ),
                    onChanged: (nutrition) async {
                      final settingsBloc = getIt<UserSettingsBloc>()
                        ..add(
                          UserSettingsEvent.usualFoodNutritionChanged(
                            usualFood.id,
                            nutrition,
                          ),
                        );
                      final mealsUsing =
                          settingsBloc.state.usualMealsUsingFood(usualFood.id);
                      if (mealsUsing == 0) return;
                      final confirmed = await ConfirmDialog.show(
                        context,
                        title: 'Update meals too?',
                        message: 'This food is used in $mealsUsing usual '
                            '${mealsUsing == 1 ? 'meal' : 'meals'}. Update '
                            '${mealsUsing == 1 ? 'it' : 'them'} to match'
                            ' the new nutrition?',
                        confirmLabel: 'Update',
                      );
                      if (!context.mounted) return;
                      if (!confirmed) return;
                      settingsBloc.add(
                        UserSettingsEvent.usualFoodPropagatedToMeals(
                          usualFood.id,
                          nutrition,
                        ),
                      );
                    },
                    onRemoved: () async {
                      final confirmed = await ConfirmDialog.show(
                        context,
                        title: 'Delete usual food?',
                        message:
                            'This permanently deletes "${usualFood.name}". '
                            'Meals you already built with it are unaffected.',
                        confirmLabel: 'Delete',
                        isDestructive: true,
                      );
                      if (!confirmed) return;
                      getIt<UserSettingsBloc>().add(
                        UserSettingsEvent.usualFoodRemoved(usualFood.id),
                      );
                    },
                  ),
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
