import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template first_log_view}
/// Final onboarding screen: ask about the meal closest to the current time
/// so the user's first real log happens inside onboarding.
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
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const OnboardingTopBar(
        step: OnboardingStep.firstLog,
        showSkip: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppDesign.spacing.xl),
          child:
              BlocSelector<
                OnboardingBloc,
                OnboardingState,
                (List<UsualMeal>, List<String>, Map<String, int>)
              >(
                bloc: getIt<OnboardingBloc>(),
                selector: (state) => (
                  state.settings.usuals[_mealOfTheDay] ?? <UsualMeal>[],
                  state.firstLogSelectedIds,
                  state.firstLogQuantities,
                ),
                builder: (context, selected) {
                  final (usualMeals, selectedIds, quantities) = selected;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Did you eat ${_mealOfTheDay.name} today?',
                        style: textTheme.headlineSmall,
                      ),
                      SizedBox(height: AppDesign.spacing.sm),
                      const Text('Tap everything you had.'),
                      SizedBox(height: AppDesign.spacing.xl),
                      Expanded(
                        child: usualMeals.isEmpty
                            ? Center(
                                child: Text(
                                  'No ${_mealOfTheDay.name} usual meals yet. '
                                  'Tap "I ate something else" to add what '
                                  'you had.',
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : GridView.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: AppDesign.spacing.md,
                                crossAxisSpacing: AppDesign.spacing.md,
                                childAspectRatio: 165 / 134,
                                children: [
                                  for (final usualMeal in usualMeals)
                                    _FoodCard(
                                      usualMeal: usualMeal,
                                      selected: selectedIds.contains(
                                        usualMeal.id,
                                      ),
                                      quantity: quantities[usualMeal.id] ?? 1,
                                    ),
                                ],
                              ),
                      ),
                      SizedBox(height: AppDesign.spacing.md),
                      OnboardingActions(
                        above: OutlinedButton.icon(
                          onPressed: () async {
                            final results =
                                await showModalBottomSheet<
                                  List<FoodEntryResult>
                                >(
                                  context: context,
                                  isScrollControlled: true,
                                  useSafeArea: true,
                                  showDragHandle: true,
                                  builder: (context) => const FoodEntrySheet(
                                    title: 'Log something else',
                                    confirmLabel: 'Log',
                                  ),
                                );
                            if (results == null) return;
                            for (final result in results) {
                              getIt<OnboardingBloc>().add(
                                OnboardingEvent.somethingElseLogged(
                                  _mealOfTheDay,
                                  result.name,
                                  nutrition: result.nutrition,
                                  quantity: result.quantity,
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
                          child: Text("I didn't eat ${_mealOfTheDay.name}"),
                        ),
                      ),
                    ],
                  );
                },
              ),
        ),
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
  final int quantity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(AppDesign.radius.sm),
      onTap: () => getIt<OnboardingBloc>().add(
        OnboardingEvent.firstLogItemToggled(usualMeal.id),
      ),
      child: Container(
        padding: EdgeInsets.all(AppDesign.spacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDesign.radius.sm),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppDesign.radius.sm),
                ),
                child: const Icon(Icons.image_outlined),
              ),
            ),
            SizedBox(height: AppDesign.spacing.sm),
            Text(
              usualMeal.name,
              style: theme.textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (selected) ...[
              SizedBox(height: AppDesign.spacing.sm),
              QuantityStepper(
                dense: true,
                quantity: quantity,
                onChanged: (quantity) => getIt<OnboardingBloc>().add(
                  OnboardingEvent.firstLogItemQuantityChanged(
                    usualMeal.id,
                    quantity,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
