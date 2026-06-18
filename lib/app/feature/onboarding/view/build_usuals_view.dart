import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template build_usuals_view}
/// Second onboarding screen: build the per-meal usuals library. A meal-timing
/// toggle selects which meal is being edited; below it the shared
/// [FoodEntryForm] captures that meal's usuals with the same fields and AI
/// assist used everywhere else the user enters food. Entries are committed to
/// the draft when the step is left.
/// {@endtemplate}
class BuildUsualsView extends StatefulWidget {
  /// {@macro build_usuals_view}
  const BuildUsualsView({super.key});

  @override
  State<BuildUsualsView> createState() => _BuildUsualsViewState();
}

class _BuildUsualsViewState extends State<BuildUsualsView> {
  late MealOfTheDay _selectedMealOfTheDay;
  late final Map<MealOfTheDay, GlobalKey<FoodEntryFormState>> _formKeys;
  late final Map<MealOfTheDay, List<FoodEntryResult>> _initialFoods;

  @override
  void initState() {
    super.initState();
    _selectedMealOfTheDay = MealOfTheDay.values.first;
    final usuals = getIt<OnboardingBloc>().state.settings.usuals;
    _formKeys = {
      for (final mealOfTheDay in MealOfTheDay.values)
        mealOfTheDay: GlobalKey<FoodEntryFormState>(),
    };
    _initialFoods = {
      for (final mealOfTheDay in MealOfTheDay.values)
        mealOfTheDay: [
          for (final usualMeal in usuals[mealOfTheDay] ?? const <UsualMeal>[])
            (
              name: usualMeal.name,
              nutrition: usualMeal.nutrition,
              quantity: 1.0,
              addToUsualMeals: false,
            ),
        ],
    };
  }

  /// Writes every meal's current rows back to the draft. Called when the step
  /// is left so nothing the user entered, on any tab, is lost.
  void _commitAllMeals() {
    final onboardingBloc = getIt<OnboardingBloc>();
    for (final mealOfTheDay in MealOfTheDay.values) {
      final results =
          _formKeys[mealOfTheDay]?.currentState?.results ?? const [];
      onboardingBloc.add(
        OnboardingEvent.usualsForMealReplaced(mealOfTheDay, [
          for (final result in results)
            (name: result.name, nutrition: result.nutrition),
        ]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return OnboardingScaffold(
      resizeToAvoidBottomInset: false,
      appBar: const OnboardingTopBar(step: OnboardingStep.buildUsuals),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Add your usual meals', style: textTheme.headlineSmall),
          SizedBox(height: AppDesign.spacing.sm),
          Text(
            'Add what you usually eat for each meal. You can edit these '
            'anytime — while logging, or later in Settings.',
            style: textTheme.bodyMedium,
          ),
          SizedBox(height: AppDesign.spacing.lg),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<MealOfTheDay>(
              showSelectedIcon: false,
              segments: [
                for (final mealOfTheDay in MealOfTheDay.values)
                  ButtonSegment(
                    value: mealOfTheDay,
                    label: Text(mealOfTheDay.label),
                  ),
              ],
              selected: {_selectedMealOfTheDay},
              onSelectionChanged: (selection) => setState(
                () => _selectedMealOfTheDay = selection.first,
              ),
            ),
          ),
          SizedBox(height: AppDesign.spacing.lg),
          Expanded(
            child: IndexedStack(
              index: MealOfTheDay.values.indexOf(_selectedMealOfTheDay),
              children: [
                for (final mealOfTheDay in MealOfTheDay.values)
                  SingleChildScrollView(
                    child: FoodEntryForm(
                      key: _formKeys[mealOfTheDay],
                      initialFoods: _initialFoods[mealOfTheDay],
                      showQuantity: false,
                      autofocusFirst: false,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: AppDesign.spacing.md),
          OnboardingActions(
            primary: FilledButton(
              onPressed: () {
                _commitAllMeals();
                getIt<OnboardingBloc>().add(
                  const OnboardingEvent.continuePressed(),
                );
              },
              child: const Text('Continue'),
            ),
            secondary: TextButton(
              onPressed: () {
                _commitAllMeals();
                getIt<OnboardingBloc>().add(
                  const OnboardingEvent.skipPressed(),
                );
              },
              child: const Text('Skip for now'),
            ),
          ),
        ],
      ),
    );
  }
}
