import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template usual_workouts_tile}
/// Settings tile summarizing the usual workouts library, navigating to the
/// usual workouts screen.
/// {@endtemplate}
class UsualWorkoutsTile extends StatelessWidget {
  /// {@macro usual_workouts_tile}
  const UsualWorkoutsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      UserSettingsBloc,
      UserSettingsState,
      (List<WorkoutGroup>, Map<String, List<UsualWorkout>>)
    >(
      bloc: getIt<UserSettingsBloc>(),
      selector: (state) => (state.workoutGroups, state.usualWorkouts),
      builder: (context, selected) {
        final (workoutGroups, usualWorkouts) = selected;
        final total = usualWorkouts.values.fold(
          0,
          (sum, workouts) => sum + workouts.length,
        );
        final sortedGroups = [...workoutGroups]
          ..sort((a, b) => a.order.compareTo(b.order));
        final summaryParts = <String>['$total items'];
        for (final workoutGroup in sortedGroups) {
          final count = usualWorkouts[workoutGroup.id]?.length ?? 0;
          summaryParts.add('${workoutGroup.name} $count');
        }
        final summary = summaryParts.join(' · ');
        return SettingsNavRow(
          title: 'Your usual workouts',
          subtitle: summary,
          onTap: () => context.push(Routes.usualWorkouts),
        );
      },
    );
  }
}
