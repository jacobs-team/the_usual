import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template weight_tracking_view}
/// Fifth onboarding screen: weigh-in cadence, time of day, and starting
/// weight with a unit toggle.
/// {@endtemplate}
class WeightTrackingView extends StatefulWidget {
  /// {@macro weight_tracking_view}
  const WeightTrackingView({super.key});

  @override
  State<WeightTrackingView> createState() => _WeightTrackingViewState();
}

class _WeightTrackingViewState extends State<WeightTrackingView> {
  late final TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    final weight = getIt<OnboardingBloc>().state.settings.startingWeight;
    _weightController = TextEditingController(
      text: weight == null ? '' : weight.toString(),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const OnboardingTopBar(step: OnboardingStep.weightTracking),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child:
              BlocSelector<
                OnboardingBloc,
                OnboardingState,
                (WeightCheckinFrequency, WeightTimeOfDay, WeightUnit)
              >(
                bloc: getIt<OnboardingBloc>(),
                selector: (state) => (
                  state.settings.weightCheckinFrequency,
                  state.settings.weightTimeOfDay,
                  state.settings.weightUnit,
                ),
                builder: (context, selected) {
                  final (frequency, timeOfDay, unit) = selected;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Weight check-ins', style: textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      const Text('A quick weigh-in keeps the trend honest.'),
                      const SizedBox(height: 20),
                      Text('HOW OFTEN', style: textTheme.labelSmall),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          for (final option in WeightCheckinFrequency.values)
                            ChoiceChip(
                              label: Text(switch (option) {
                                WeightCheckinFrequency.daily => 'Daily',
                                WeightCheckinFrequency.everyTwoDays =>
                                  'Every 2 days',
                                WeightCheckinFrequency.weekly => 'Weekly',
                                WeightCheckinFrequency.off => 'Off',
                              }),
                              selected: option == frequency,
                              onSelected: (_) => getIt<OnboardingBloc>().add(
                                OnboardingEvent.weightCheckinFrequencySelected(
                                  option,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (frequency == WeightCheckinFrequency.off)
                        Text(
                          'No weight check-ins. You can turn them on any time '
                          'in Settings.',
                          style: textTheme.bodySmall,
                        )
                      else ...[
                        Text('WHAT TIME OF DAY', style: textTheme.labelSmall),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            for (final option in WeightTimeOfDay.values)
                              ChoiceChip(
                                label: Text(switch (option) {
                                  WeightTimeOfDay.morning =>
                                    'Morning · recommended',
                                  WeightTimeOfDay.evening => 'Evening',
                                  WeightTimeOfDay.night => 'Night',
                                }),
                                selected: option == timeOfDay,
                                onSelected: (_) => getIt<OnboardingBloc>().add(
                                  OnboardingEvent.weightTimeOfDaySelected(
                                    option,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Morning weigh-ins are the most consistent.',
                          style: textTheme.bodySmall,
                        ),
                        const SizedBox(height: 20),
                        Text('STARTING WEIGHT', style: textTheme.labelSmall),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _weightController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d{0,4}\.?\d{0,1}'),
                            ),
                          ],
                          style: textTheme.headlineMedium,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (final option in WeightUnit.values)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: ChoiceChip(
                                        label: Text(option.name),
                                        selected: option == unit,
                                        onSelected: (_) =>
                                            getIt<OnboardingBloc>().add(
                                              OnboardingEvent.weightUnitSelected(
                                                option,
                                              ),
                                            ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          onChanged: (value) => getIt<OnboardingBloc>().add(
                            OnboardingEvent.startingWeightChanged(
                              double.tryParse(value),
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
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
        ),
      ),
    );
  }
}
