import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template exercise_progress_detail_view}
/// One exercise's strength progress: its estimated-1RM chart over all sessions
/// and a reverse-chronological list of those sessions. Tapping a chart point
/// surfaces that session's top set above the list.
/// {@endtemplate}
class ExerciseProgressDetailView extends StatefulWidget {
  /// {@macro exercise_progress_detail_view}
  const ExerciseProgressDetailView({required this.exerciseName, super.key});

  /// The display name of the exercise to chart, matched against
  final String exerciseName;

  @override
  State<ExerciseProgressDetailView> createState() =>
      _ExerciseProgressDetailViewState();
}

class _ExerciseProgressDetailViewState
    extends State<ExerciseProgressDetailView> {
  ExerciseStrengthPoint? _selectedPoint;

  @override
  Widget build(BuildContext context) {
    final dayStart = getIt<UserSettingsBloc>().state.dayStartTime;
    final weightUnit = getIt<UserSettingsBloc>().state.workoutWeightUnit;

    return Scaffold(
      appBar: TheUsualAppBar(title: widget.exerciseName),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<WorkoutLogBloc, WorkoutLogState>(
          bloc: getIt<WorkoutLogBloc>(),
          builder: (context, state) {
            final matching = state
                .strengthProgress(dayStart)
                .where((series) => series.name == widget.exerciseName);
            final series = matching.isEmpty ? null : matching.first;

            if (series == null) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(AppDesign.spacing.xl),
                  child: Text(
                    'Not enough sessions yet to chart this exercise.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            }

            final selectedPoint = _selectedPoint ?? series.points.last;
            final localizations = MaterialLocalizations.of(context);
            final sessionsNewestFirst = series.points.reversed.toList();

            return ListView(
              padding: EdgeInsets.fromLTRB(
                AppDesign.spacing.lg,
                AppDesign.spacing.sm,
                AppDesign.spacing.lg,
                AppDesign.spacing.xl,
              ),
              children: [
                ExerciseStrengthChart(
                  points: series.points,
                  weightUnit: weightUnit,
                  onPointSelected: (point) =>
                      setState(() => _selectedPoint = point),
                ),
                Text(
                  '${localizations.formatMediumDate(selectedPoint.sessionDay)}'
                  ' · '
                  '${selectedPoint.topSet.label} · '
                  '${selectedPoint.estimatedOneRepMax.trimmedDecimal} '
                  '${weightUnit.name} est. max',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: AppDesign.spacing.lg),
                const SectionLabel('SESSIONS'),
                for (final point in sessionsNewestFirst)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(DateFormat.yMMMd().format(point.sessionDay)),
                    subtitle: Text(point.topSet.label),
                    trailing: Text(
                      '${point.estimatedOneRepMax.trimmedDecimal} '
                      '${weightUnit.name}',
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
