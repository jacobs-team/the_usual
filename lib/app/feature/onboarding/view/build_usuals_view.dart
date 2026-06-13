import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

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
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child:
                    BlocSelector<
                      OnboardingBloc,
                      OnboardingState,
                      Map<MealOfTheDay, List<UsualMeal>>
                    >(
                      bloc: getIt<OnboardingBloc>(),
                      selector: (state) => state.settings.usuals,
                      builder: (context, usuals) {
                        return ListView(
                          children: [
                            Text(
                              'Add your usual meals',
                              style: textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Add what you usually eat for each meal. You can '
                              'edit these anytime — on the fly while logging, '
                              'or later in Settings.',
                              style: textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 24),
                            for (final mealOfTheDay in MealOfTheDay.values) ...[
                              UsualMealSection(
                                mealOfTheDay: mealOfTheDay,
                                usualMeals:
                                    usuals[mealOfTheDay] ?? const <UsualMeal>[],
                                onAdded: (name, calories) =>
                                    getIt<OnboardingBloc>().add(
                                      OnboardingEvent.usualMealAdded(
                                        mealOfTheDay,
                                        name,
                                        calories,
                                      ),
                                    ),
                                onCaloriesChanged: (id, calories) =>
                                    getIt<OnboardingBloc>().add(
                                      OnboardingEvent.usualMealCaloriesChanged(
                                        mealOfTheDay,
                                        id,
                                        calories,
                                      ),
                                    ),
                                onRemoved: (id) => getIt<OnboardingBloc>().add(
                                  OnboardingEvent.usualMealRemoved(
                                    mealOfTheDay,
                                    id,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 28),
                            ],
                          ],
                        );
                      },
                    ),
              ),
              const SizedBox(height: 12),
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
