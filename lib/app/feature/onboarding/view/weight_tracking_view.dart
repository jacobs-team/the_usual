import 'package:flutter/material.dart';
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
                      const SectionLabel('HOW OFTEN'),
                      const SizedBox(height: 8),
                      WeightCheckinFrequencyChips(
                        selected: frequency,
                        onSelected: (frequency) => getIt<OnboardingBloc>().add(
                          OnboardingEvent.weightCheckinFrequencySelected(
                            frequency,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (frequency == WeightCheckinFrequency.off)
                        Text(
                          'No weight check-ins. You can turn them on any time '
                          'in Settings.',
                          style: textTheme.bodySmall,
                        )
                      else ...[
                        const SectionLabel('WHAT TIME OF DAY'),
                        const SizedBox(height: 8),
                        WeightTimeOfDayChips(
                          selected: timeOfDay,
                          onSelected: (timeOfDay) =>
                              getIt<OnboardingBloc>().add(
                                OnboardingEvent.weightTimeOfDaySelected(
                                  timeOfDay,
                                ),
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Morning weigh-ins are the most consistent.',
                          style: textTheme.bodySmall,
                        ),
                        const SizedBox(height: 20),
                        const SectionLabel('STARTING WEIGHT'),
                        const SizedBox(height: 8),
                        WeightInput(
                          controller: _weightController,
                          unit: unit,
                          onWeightChanged: (weight) =>
                              getIt<OnboardingBloc>().add(
                                OnboardingEvent.startingWeightChanged(weight),
                              ),
                          onUnitSelected: (unit) => getIt<OnboardingBloc>().add(
                            OnboardingEvent.weightUnitSelected(unit),
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
