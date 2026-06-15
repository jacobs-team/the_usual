import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template build_usuals_view}
/// Second onboarding screen: build the per-meal usuals library by typing a
/// name and optional calories for each meal time, all on one scrolling view.
/// {@endtemplate}
class BuildUsualsView extends StatelessWidget {
  /// {@macro build_usuals_view}
  const BuildUsualsView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const OnboardingTopBar(step: OnboardingStep.buildUsuals),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppDesign.spacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child:
                    BlocSelector<
                      OnboardingBloc,
                      OnboardingState,
                      (Map<MealOfTheDay, List<UsualMeal>>, bool)
                    >(
                      bloc: getIt<OnboardingBloc>(),
                      selector: (state) => (
                        state.settings.usuals,
                        state.settings.expandNutritionByDefault,
                      ),
                      builder: (context, selected) {
                        final (usuals, expandNutritionByDefault) = selected;
                        return ListView(
                          children: [
                            Text(
                              'Add your usual meals',
                              style: textTheme.headlineSmall,
                            ),
                            SizedBox(height: AppDesign.spacing.md),
                            Text(
                              'Add what you usually eat for each meal. You can '
                              'edit these anytime — on the fly while logging, '
                              'or later in Settings.',
                              style: textTheme.bodyMedium,
                            ),
                            SizedBox(height: AppDesign.spacing.xl),
                            for (final mealOfTheDay in MealOfTheDay.values) ...[
                              UsualMealSection(
                                mealOfTheDay: mealOfTheDay,
                                usualMeals:
                                    usuals[mealOfTheDay] ?? const <UsualMeal>[],
                                expandedByDefault: expandNutritionByDefault,
                                onAdded: (name, nutrition) =>
                                    getIt<OnboardingBloc>().add(
                                      OnboardingEvent.usualMealAdded(
                                        mealOfTheDay,
                                        name,
                                        nutrition,
                                      ),
                                    ),
                                onNutritionChanged: (id, nutrition) =>
                                    getIt<OnboardingBloc>().add(
                                      OnboardingEvent.usualMealNutritionChanged(
                                        mealOfTheDay,
                                        id,
                                        nutrition,
                                      ),
                                    ),
                                onRemoved: (id) => getIt<OnboardingBloc>().add(
                                  OnboardingEvent.usualMealRemoved(
                                    mealOfTheDay,
                                    id,
                                  ),
                                ),
                              ),
                              SizedBox(height: AppDesign.spacing.xl),
                            ],
                          ],
                        );
                      },
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
                secondary: TextButton(
                  onPressed: () => getIt<OnboardingBloc>().add(
                    const OnboardingEvent.skipPressed(),
                  ),
                  child: const Text('Skip for now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
