import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template exercises_lens}
/// The Progress screen's Exercises lens: a list of strength exercises, each
/// showing its estimated-1RM sparkline and latest estimate, most recently
/// trained first. Tapping a row opens that exercise's progress detail.
/// {@endtemplate}
class ExercisesLens extends StatelessWidget {
  /// {@macro exercises_lens}
  const ExercisesLens({super.key});

  @override
  Widget build(BuildContext context) {
    final dayStart = getIt<UserSettingsBloc>().state.dayStartTime;
    final weightUnit = getIt<UserSettingsBloc>().state.workoutWeightUnit;

    return BlocBuilder<WorkoutLogBloc, WorkoutLogState>(
      bloc: getIt<WorkoutLogBloc>(),
      builder: (context, state) {
        final progress = state.strengthProgress(dayStart);
        if (progress.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(AppDesign.spacing.xl),
              child: Text(
                'Log a strength exercise on two or more days and its progress '
                'shows up here.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.fromLTRB(
            AppDesign.spacing.lg,
            AppDesign.spacing.sm,
            AppDesign.spacing.lg,
            AppDesign.spacing.xl,
          ),
          itemCount: progress.length,
          itemBuilder: (context, index) {
            final series = progress[index];
            final latest = series.points.last.estimatedOneRepMax;
            return Card(
              margin: EdgeInsets.only(bottom: AppDesign.spacing.sm),
              child: ListTile(
                title: Text(series.name),
                subtitle: SizedBox(
                  height: 24,
                  child: ExerciseSparkline(
                    values: [
                      for (final point in series.points)
                        point.estimatedOneRepMax,
                    ],
                  ),
                ),
                trailing: Text(
                  '${latest.trimmedDecimal} ${weightUnit.name}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        ExerciseProgressDetailView(exerciseName: series.name),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
