import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template first_log_view}
/// Onboarding screen that asks what the user ate today, listing every usual
/// grouped by meal, so the user's first real log happens inside onboarding.
/// {@endtemplate}
class FirstLogView extends StatefulWidget {
  /// {@macro first_log_view}
  const FirstLogView({super.key});

  @override
  State<FirstLogView> createState() => _FirstLogViewState();
}

class _FirstLogViewState extends State<FirstLogView> {
  late final MealOfTheDay _mealOfTheDay;

  @override
  void initState() {
    super.initState();
    _mealOfTheDay = MealOfTheDay.fromTime(TimeOfDay.fromDateTime(clock.now()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return OnboardingScaffold(
      appBar: const OnboardingTopBar(step: OnboardingStep.firstLog),
      child:
          BlocSelector<
            OnboardingBloc,
            OnboardingState,
            (
              Map<MealOfTheDay, List<UsualMeal>>,
              List<String>,
              Map<String, double>,
            )
          >(
            bloc: getIt<OnboardingBloc>(),
            selector: (state) => (
              state.settings.usuals,
              state.firstLogSelectedIds,
              state.firstLogQuantities,
            ),
            builder: (context, selected) {
              final (usualsByMeal, selectedIds, quantities) = selected;
              final mealsWithUsuals = [
                for (final mealOfTheDay in MealOfTheDay.values)
                  if ((usualsByMeal[mealOfTheDay] ?? const <UsualMeal>[])
                      .isNotEmpty)
                    mealOfTheDay,
              ];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Did you eat today?', style: textTheme.headlineSmall),
                  SizedBox(height: AppDesign.spacing.sm),
                  const Text('Tap everything you had.'),
                  SizedBox(height: AppDesign.spacing.xl),
                  Expanded(
                    child: mealsWithUsuals.isEmpty
                        ? const Center(
                            child: Text(
                              'No usual meals yet. Tap "I ate something else" '
                              'to add what you had.',
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView(
                            children: [
                              for (final mealOfTheDay in mealsWithUsuals) ...[
                                if (mealOfTheDay != mealsWithUsuals.first)
                                  SizedBox(height: AppDesign.spacing.lg),
                                Text(
                                  mealOfTheDay.label.toUpperCase(),
                                  style: textTheme.labelMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                for (final usualMeal
                                    in usualsByMeal[mealOfTheDay]!) ...[
                                  SizedBox(height: AppDesign.spacing.sm),
                                  _FoodCard(
                                    usualMeal: usualMeal,
                                    selected: selectedIds.contains(
                                      usualMeal.id,
                                    ),
                                    quantity: quantities[usualMeal.id] ?? 1,
                                  ),
                                ],
                              ],
                            ],
                          ),
                  ),
                  SizedBox(height: AppDesign.spacing.md),
                  OnboardingActions(
                    above: OutlinedButton.icon(
                      onPressed: () async {
                        final result =
                            await TheUsualBottomSheet.show<
                              FoodEntrySheetResult
                            >(
                              context,
                              builder: (context) => const FoodEntrySheet(
                                title: 'Log something else',
                                confirmLabel: 'Log',
                              ),
                            );
                        if (result == null) return;
                        for (final foodResult in result.foods) {
                          getIt<OnboardingBloc>().add(
                            OnboardingEvent.somethingElseLogged(
                              _mealOfTheDay,
                              foodResult.name,
                              nutrition: foodResult.nutrition,
                              quantity: foodResult.quantity,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('I ate something else'),
                    ),
                    primary: FilledButton(
                      onPressed: selectedIds.isEmpty
                          ? null
                          : () => getIt<OnboardingBloc>().add(
                              const OnboardingEvent.continuePressed(),
                            ),
                      child: const Text('Log it'),
                    ),
                    secondary: TextButton(
                      onPressed: () => getIt<OnboardingBloc>().add(
                        const OnboardingEvent.continuePressed(),
                      ),
                      child: const Text("I haven't eaten yet"),
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }
}

class _FoodCard extends StatelessWidget {
  const _FoodCard({
    required this.usualMeal,
    required this.selected,
    required this.quantity,
  });

  final UsualMeal usualMeal;
  final bool selected;
  final double quantity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDesign.radius.md),
        side: BorderSide(
          color: selected ? colorScheme.primary : colorScheme.outlineVariant,
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => getIt<OnboardingBloc>().add(
          OnboardingEvent.firstLogItemToggled(usualMeal.id),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppDesign.spacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      usualMeal.name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (!usualMeal.nutrition.isEmpty) ...[
                      SizedBox(height: AppDesign.spacing.xs),
                      DefaultTextStyle.merge(
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        child: NutritionSummary(usualMeal.nutrition),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: AppDesign.spacing.md),
              if (selected)
                QuantityStepper(
                  dense: true,
                  quantity: quantity,
                  onChanged: (quantity) => getIt<OnboardingBloc>().add(
                    OnboardingEvent.firstLogItemQuantityChanged(
                      usualMeal.id,
                      quantity,
                    ),
                  ),
                )
              else
                Icon(Icons.add, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
