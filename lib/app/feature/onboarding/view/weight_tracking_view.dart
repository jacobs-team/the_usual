import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

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
          padding: EdgeInsets.all(AppDesign.spacing.xl),
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
                  final (
                    weightCheckinFrequency,
                    weightTimeOfDay,
                    weightUnit,
                  ) = selected;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Weight check-ins',
                                style: textTheme.headlineSmall,
                              ),
                              SizedBox(height: AppDesign.spacing.sm),
                              const Text(
                                'A quick weigh-in keeps the trend honest.',
                              ),
                              SizedBox(height: AppDesign.spacing.xl),
                              const SectionLabel('HOW OFTEN'),
                              SizedBox(height: AppDesign.spacing.sm),
                              WeightCheckinFrequencyChips(
                                selected: weightCheckinFrequency,
                                onSelected: (weightCheckinFrequency) {
                                  getIt<OnboardingBloc>().add(
                                    // ignore: lines_longer_than_80_chars
                                    OnboardingEvent.weightCheckinFrequencySelected(
                                      weightCheckinFrequency,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: AppDesign.spacing.xl),
                              if (weightCheckinFrequency ==
                                  WeightCheckinFrequency.off)
                                Text(
                                  'No weight check-ins. You can turn them on '
                                  'any time in Settings.',
                                  style: textTheme.bodySmall,
                                )
                              else ...[
                                const SectionLabel('WHAT TIME OF DAY'),
                                SizedBox(height: AppDesign.spacing.sm),
                                WeightTimeOfDayChips(
                                  selected: weightTimeOfDay,
                                  onSelected: (weightTimeOfDay) =>
                                      getIt<OnboardingBloc>().add(
                                        OnboardingEvent.weightTimeOfDaySelected(
                                          weightTimeOfDay,
                                        ),
                                      ),
                                ),
                                SizedBox(height: AppDesign.spacing.sm),
                                Text(
                                  'Morning weigh-ins are the most consistent.',
                                  style: textTheme.bodySmall,
                                ),
                                SizedBox(height: AppDesign.spacing.xl),
                                const SectionLabel('STARTING WEIGHT'),
                                SizedBox(height: AppDesign.spacing.sm),
                                WeightInput(
                                  controller: _weightController,
                                  weightUnit: weightUnit,
                                  onWeightChanged: (weight) =>
                                      getIt<OnboardingBloc>().add(
                                        OnboardingEvent.startingWeightChanged(
                                          weight,
                                        ),
                                      ),
                                  onUnitSelected: (weightUnit) =>
                                      getIt<OnboardingBloc>().add(
                                        OnboardingEvent.weightUnitSelected(
                                          weightUnit,
                                        ),
                                      ),
                                ),
                              ],
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
        ),
      ),
    );
  }
}
