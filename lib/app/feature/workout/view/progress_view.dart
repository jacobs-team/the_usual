import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// The two lenses on workout history the Progress screen toggles between.
enum _ProgressLens { exercises, days }

/// {@template progress_view}
/// Workout progress and history. A segmented control toggles the Exercises lens
/// (per-exercise estimated-1RM charts) and the Days lens (the day-by-day
/// journal).
/// {@endtemplate}
class ProgressView extends StatefulWidget {
  /// {@macro progress_view}
  const ProgressView({super.key});

  @override
  State<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  _ProgressLens _lens = _ProgressLens.exercises;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TheUsualAppBar(title: 'Progress'),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDesign.spacing.lg,
                vertical: AppDesign.spacing.md,
              ),
              child: SegmentedButton<_ProgressLens>(
                segments: const [
                  ButtonSegment(
                    value: _ProgressLens.exercises,
                    label: Text('Exercises'),
                    icon: Icon(Icons.show_chart),
                  ),
                  ButtonSegment(
                    value: _ProgressLens.days,
                    label: Text('Days'),
                    icon: Icon(Icons.calendar_month_outlined),
                  ),
                ],
                selected: {_lens},
                onSelectionChanged: (selection) =>
                    setState(() => _lens = selection.first),
              ),
            ),
            Expanded(
              child: switch (_lens) {
                _ProgressLens.exercises => const ExercisesLens(),
                _ProgressLens.days => const WorkoutDaysLens(),
              },
            ),
          ],
        ),
      ),
    );
  }
}
