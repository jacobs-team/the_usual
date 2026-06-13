import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template weight_section}
/// Settings section for weight check-ins: frequency, time of day, and the
/// current weight with a unit toggle. Shows an off notice when check-ins are
/// disabled.
/// {@endtemplate}
class WeightSection extends StatefulWidget {
  /// {@macro weight_section}
  const WeightSection({super.key});

  @override
  State<WeightSection> createState() => _WeightSectionState();
}

class _WeightSectionState extends State<WeightSection> {
  late final TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    final weight = getIt<UserSettingsBloc>().state.startingWeight;
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
    return BlocSelector<
      UserSettingsBloc,
      UserSettingsState,
      (WeightCheckinFrequency, WeightTimeOfDay, WeightUnit)
    >(
      bloc: getIt<UserSettingsBloc>(),
      selector: (state) => (
        state.weightCheckinFrequency,
        state.weightTimeOfDay,
        state.weightUnit,
      ),
      builder: (context, selected) {
        final (weightCheckinFrequency, weightTimeOfDay, weightUnit) = selected;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('How often', style: textTheme.bodySmall),
            SizedBox(height: AppDesign.spacing.sm),
            WeightCheckinFrequencyChips(
              selected: weightCheckinFrequency,
              onSelected: (weightCheckinFrequency) =>
                  getIt<UserSettingsBloc>().add(
                    UserSettingsEvent.weightCheckinFrequencySelected(
                      weightCheckinFrequency,
                    ),
                  ),
            ),
            SizedBox(height: AppDesign.spacing.md),
            if (weightCheckinFrequency == WeightCheckinFrequency.off)
              const InfoBox(
                'Weight check-ins are off. Pick a frequency to turn them '
                'back on.',
              )
            else ...[
              Text('What time of day', style: textTheme.bodySmall),
              SizedBox(height: AppDesign.spacing.sm),
              WeightTimeOfDayChips(
                selected: weightTimeOfDay,
                onSelected: (weightTimeOfDay) => getIt<UserSettingsBloc>().add(
                  UserSettingsEvent.weightTimeOfDaySelected(weightTimeOfDay),
                ),
              ),
              SizedBox(height: AppDesign.spacing.md),
              Text('Starting weight', style: textTheme.bodySmall),
              SizedBox(height: AppDesign.spacing.sm),
              WeightInput(
                controller: _weightController,
                weightUnit: weightUnit,
                onWeightChanged: (weight) => getIt<UserSettingsBloc>().add(
                  UserSettingsEvent.startingWeightChanged(weight),
                ),
                onUnitSelected: (weightUnit) => getIt<UserSettingsBloc>().add(
                  UserSettingsEvent.weightUnitSelected(weightUnit),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
