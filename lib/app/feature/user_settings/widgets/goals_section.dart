import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template goals_section}
/// Settings section for the user's optional targets: a daily calorie goal and
/// a goal weight. Both can be cleared to leave the goal unset.
/// {@endtemplate}
class GoalsSection extends StatefulWidget {
  /// {@macro goals_section}
  const GoalsSection({super.key});

  @override
  State<GoalsSection> createState() => _GoalsSectionState();
}

class _GoalsSectionState extends State<GoalsSection> {
  late final TextEditingController _calorieGoalController;
  late final TextEditingController _weightGoalController;

  @override
  void initState() {
    super.initState();
    final state = getIt<UserSettingsBloc>().state;
    _calorieGoalController = TextEditingController(
      text: state.calorieGoal?.toString() ?? '',
    );
    _weightGoalController = TextEditingController(
      text: state.weightGoal?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _calorieGoalController.dispose();
    _weightGoalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocListener<UserSettingsBloc, UserSettingsState>(
      bloc: getIt<UserSettingsBloc>(),
      listenWhen: (previous, current) =>
          previous.calorieGoal != current.calorieGoal ||
          previous.weightGoal != current.weightGoal,
      listener: (context, state) {
        // Re-seed the fields when the values change underneath us (a cloud
        // restore on sign-in or a sync from another device). Compared
        // numerically so the user's own keystrokes, which echo back as the same
        // value, don't reset the cursor mid-edit.
        if (int.tryParse(_calorieGoalController.text) != state.calorieGoal) {
          _calorieGoalController.text = state.calorieGoal?.toString() ?? '';
        }
        if (double.tryParse(_weightGoalController.text) != state.weightGoal) {
          _weightGoalController.text = state.weightGoal?.toString() ?? '';
        }
      },
      child: BlocSelector<UserSettingsBloc, UserSettingsState, WeightUnit>(
        bloc: getIt<UserSettingsBloc>(),
        selector: (state) => state.weightUnit,
        builder: (context, weightUnit) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Daily calorie goal', style: textTheme.bodySmall),
              SizedBox(height: AppDesign.spacing.sm),
              MacroField(
                controller: _calorieGoalController,
                unit: 'cal',
                maxDigits: 5,
                onChanged: (calorieGoal) => getIt<UserSettingsBloc>().add(
                  UserSettingsEvent.calorieGoalChanged(calorieGoal),
                ),
              ),
              SizedBox(height: AppDesign.spacing.md),
              Text('Goal weight', style: textTheme.bodySmall),
              SizedBox(height: AppDesign.spacing.sm),
              WeightInput(
                controller: _weightGoalController,
                weightUnit: weightUnit,
                onWeightChanged: (weightGoal) => getIt<UserSettingsBloc>().add(
                  UserSettingsEvent.weightGoalChanged(weightGoal),
                ),
                onUnitSelected: (weightUnit) => getIt<UserSettingsBloc>().add(
                  UserSettingsEvent.weightUnitSelected(weightUnit),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
