import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

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
  late final MealOfTheDay _meal;

  @override
  void initState() {
    super.initState();
    _meal = MealOfTheDay.fromTime(TimeOfDay.now());
  }

  Future<void> _showSomethingElseDialog() async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) => const AteSomethingElseDialog(),
    );
    if (name != null && name.trim().isNotEmpty) {
      getIt<OnboardingBloc>().add(
        OnboardingEvent.somethingElseLogged(_meal, name),
      );
    }
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
          padding: const EdgeInsets.all(24),
          child:
              BlocSelector<
                OnboardingBloc,
                OnboardingState,
                (List<UsualMeal>, List<String>)
              >(
                bloc: getIt<OnboardingBloc>(),
                selector: (state) => (
                  state.settings.usuals[_meal] ?? <UsualMeal>[],
                  state.firstLogSelectedIds,
                ),
                builder: (context, selected) {
                  final (items, selectedIds) = selected;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Did you eat ${_meal.name} today?',
                        style: textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      const Text('Tap everything you had.'),
                      const SizedBox(height: 20),
                      Expanded(
                        child: items.isEmpty
                            ? Center(
                                child: Text(
                                  'No ${_meal.name} usual meals yet. Tap '
                                  '"I ate something else" to add what '
                                  'you had.',
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : GridView.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 165 / 134,
                                children: [
                                  for (final item in items)
                                    _FoodCard(
                                      item: item,
                                      selected: selectedIds.contains(item.id),
                                    ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 12),
                      OnboardingActions(
                        above: OutlinedButton.icon(
                          onPressed: _showSomethingElseDialog,
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
                          child: Text("I didn't eat ${_meal.name}"),
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
  const _FoodCard({required this.item, required this.selected});

  final UsualMeal item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => getIt<OnboardingBloc>().add(
        OnboardingEvent.firstLogItemToggled(item.id),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
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
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image_outlined),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.name,
              style: theme.textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
