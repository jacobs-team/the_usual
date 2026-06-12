import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

const _suggestions = <MealOfTheDay, List<String>>{
  MealOfTheDay.breakfast: [
    'Eggs & toast',
    'Oatmeal',
    'Cereal',
    'Smoothie',
    'Coffee & bagel',
    'Leftovers',
  ],
  MealOfTheDay.lunch: [
    'Sandwich',
    'Salad',
    'Chicken bowl',
    'Soup',
    'Burrito',
    'Leftovers',
  ],
  MealOfTheDay.dinner: [
    'Pasta',
    'Stir fry',
    'Tacos',
    'Pizza',
    'Chicken & rice',
    'Leftovers',
  ],
  MealOfTheDay.snacks: [
    'Yogurt',
    'Fruit',
    'Protein bar',
    'Nuts',
    'Chips',
    'Cheese & crackers',
  ],
};

/// {@template build_usuals_view}
/// Second onboarding screen: build the per-meal usuals library with
/// suggestion chips and free text entry.
/// {@endtemplate}
class BuildUsualsView extends StatefulWidget {
  /// {@macro build_usuals_view}
  const BuildUsualsView({super.key});

  @override
  State<BuildUsualsView> createState() => _BuildUsualsViewState();
}

class _BuildUsualsViewState extends State<BuildUsualsView> {
  MealOfTheDay _selectedMeal = MealOfTheDay.breakfast;
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addItem(String name) {
    getIt<OnboardingBloc>().add(
      OnboardingEvent.usualAdded(_selectedMeal, name),
    );
  }

  void _submitInput() {
    _addItem(_nameController.text);
    _nameController.clear();
  }

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
                      List<UsualMeal>
                    >(
                      bloc: getIt<OnboardingBloc>(),
                      selector: (state) =>
                          state.usuals[_selectedMeal] ?? <UsualMeal>[],
                      builder: (context, items) {
                        final itemNames = {
                          for (final item in items) item.name.toLowerCase(),
                        };
                        final suggestions = _suggestions[_selectedMeal]!
                            .where(
                              (name) => !itemNames.contains(name.toLowerCase()),
                            )
                            .toList();
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Add your usual meals',
                                style: textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Pick what you eat most. You can add more '
                                'anytime.',
                              ),
                              const SizedBox(height: 20),
                              Wrap(
                                spacing: 8,
                                children: [
                                  for (final meal in MealOfTheDay.values)
                                    ChoiceChip(
                                      label: Text(meal.label),
                                      selected: meal == _selectedMeal,
                                      onSelected: (_) => setState(
                                        () => _selectedMeal = meal,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text('SUGGESTIONS', style: textTheme.labelSmall),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (final name in suggestions)
                                    ActionChip(
                                      label: Text('+ $name'),
                                      onPressed: () => _addItem(name),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'YOUR ITEMS (${items.length})',
                                style: textTheme.labelSmall,
                              ),
                              const SizedBox(height: 8),
                              for (final item in items)
                                _UsualItemTile(meal: _selectedMeal, item: item),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  hintText: 'Add your own…',
                                  border: OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.camera_alt_outlined),
                                    // TODO(onboarding): photo capture from
                                    // camera or library.
                                    onPressed: null,
                                  ),
                                ),
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => _submitInput(),
                              ),
                            ],
                          ),
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

class _UsualItemTile extends StatelessWidget {
  const _UsualItemTile({required this.meal, required this.item});

  final MealOfTheDay meal;
  final UsualMeal item;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.image_outlined),
        ),
        title: Text(item.name),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => getIt<OnboardingBloc>().add(
            OnboardingEvent.usualRemoved(meal, item.id),
          ),
        ),
      ),
    );
  }
}
