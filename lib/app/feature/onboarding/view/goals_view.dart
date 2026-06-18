import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template goals_view}
/// Onboarding screen for the user's optional targets: a daily calorie goal and
/// a goal weight. Both are optional — the app works without them, so this step
/// makes clear it can be skipped and set later.
/// {@endtemplate}
class GoalsView extends StatefulWidget {
  /// {@macro goals_view}
  const GoalsView({super.key});

  @override
  State<GoalsView> createState() => _GoalsViewState();
}

class _GoalsViewState extends State<GoalsView> {
  late final TextEditingController _calorieGoalController;
  late final TextEditingController _weightGoalController;

  @override
  void initState() {
    super.initState();
    final settings = getIt<OnboardingBloc>().state.settings;
    _calorieGoalController = TextEditingController(
      text: settings.calorieGoal?.toString() ?? '',
    );
    _weightGoalController = TextEditingController(
      text: settings.weightGoal?.toString() ?? '',
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
    return OnboardingScaffold(
      resizeToAvoidBottomInset: false,
      appBar: const OnboardingTopBar(step: OnboardingStep.goals),
      child: BlocSelector<OnboardingBloc, OnboardingState, WeightUnit>(
        bloc: getIt<OnboardingBloc>(),
        selector: (state) => state.settings.weightUnit,
        builder: (context, weightUnit) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Your goals', style: textTheme.headlineSmall),
                      SizedBox(height: AppDesign.spacing.sm),
                      const Text(
                        "A calorie goal fills the day's nutrition bar so "
                        'you can see how much room is left. Both goals are '
                        'optional.',
                      ),
                      SizedBox(height: AppDesign.spacing.xl),
                      const SectionLabel('DAILY CALORIE GOAL'),
                      SizedBox(height: AppDesign.spacing.sm),
                      MacroField(
                        controller: _calorieGoalController,
                        unit: 'cal',
                        maxDigits: 5,
                        onChanged: (calorieGoal) => getIt<OnboardingBloc>().add(
                          OnboardingEvent.calorieGoalChanged(
                            calorieGoal,
                          ),
                        ),
                      ),
                      SizedBox(height: AppDesign.spacing.xl),
                      const SectionLabel('GOAL WEIGHT'),
                      SizedBox(height: AppDesign.spacing.sm),
                      WeightInput(
                        controller: _weightGoalController,
                        weightUnit: weightUnit,
                        onWeightChanged: (weightGoal) =>
                            getIt<OnboardingBloc>().add(
                              OnboardingEvent.weightGoalChanged(weightGoal),
                            ),
                        onUnitSelected: (weightUnit) =>
                            getIt<OnboardingBloc>().add(
                              OnboardingEvent.weightUnitSelected(
                                weightUnit,
                              ),
                            ),
                      ),
                      SizedBox(height: AppDesign.spacing.sm),
                      Text(
                        'No pressure to get these right. Skip them and add '
                        'goals in Settings whenever you figure out your '
                        'baseline.',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppDesign.spacing.md),
              OnboardingActions(
                primary: FilledButton(
                  onPressed: () => getIt<OnboardingBloc>().add(
                    const OnboardingEvent.continuePressed(),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
