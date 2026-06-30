import 'dart:async';

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
              _UsualFoodCard(
                key: ValueKey(usualFood.id),
                usualFood: usualFood,
                expandedByDefault: expandNutritionByDefault,
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

/// One usual food's editable card. Nutrition edits update the food immediately
/// and, once the user pauses, propagate to every usual meal that uses it — so
/// the meals' own copies stay in sync without a prompt on every keystroke.
class _UsualFoodCard extends StatefulWidget {
  const _UsualFoodCard({
    required this.usualFood,
    required this.expandedByDefault,
    super.key,
  });

  final UsualFood usualFood;
  final bool expandedByDefault;

  @override
  State<_UsualFoodCard> createState() => _UsualFoodCardState();
}

class _UsualFoodCardState extends State<_UsualFoodCard> {
  /// How long the user must pause editing before the new nutrition is pushed
  /// out to the usual meals that use this food.
  static const _propagationDelay = Duration(seconds: 2);

  Timer? _propagationDebounce;

  @override
  void dispose() {
    _propagationDebounce?.cancel();
    super.dispose();
  }

  void _onNutritionChanged(Nutrition nutrition) {
    final id = widget.usualFood.id;
    getIt<UserSettingsBloc>().add(
      UserSettingsEvent.usualFoodNutritionChanged(id, nutrition),
    );
    _propagationDebounce?.cancel();
    _propagationDebounce = Timer(_propagationDelay, () {
      getIt<UserSettingsBloc>().add(
        UserSettingsEvent.usualFoodPropagatedToMeals(id, nutrition),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final usualFood = widget.usualFood;
    return Card(
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
          expandedByDefault: widget.expandedByDefault,
          onNameChanged: (name) => getIt<UserSettingsBloc>().add(
            UserSettingsEvent.usualFoodNameChanged(usualFood.id, name),
          ),
          onChanged: _onNutritionChanged,
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
    );
  }
}
