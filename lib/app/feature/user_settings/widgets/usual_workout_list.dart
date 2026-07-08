import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template usual_workout_list}
/// One workout group's tab on the usual workouts screen: the saved usual
/// workouts, edited in place. New workouts are added through the screen's
/// floating action button. Kept alive so switching tabs doesn't rebuild its
/// fields.
/// {@endtemplate}
class UsualWorkoutList extends StatefulWidget {
  /// {@macro usual_workout_list}
  const UsualWorkoutList({required this.workoutGroup, super.key});

  /// The workout group this list shows.
  final WorkoutGroup workoutGroup;

  @override
  State<UsualWorkoutList> createState() => _UsualWorkoutListState();
}

class _UsualWorkoutListState extends State<UsualWorkoutList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final workoutGroup = widget.workoutGroup;
    return BlocSelector<
      UserSettingsBloc,
      UserSettingsState,
      (List<UsualWorkout>, WeightUnit, bool)
    >(
      bloc: getIt<UserSettingsBloc>(),
      selector: (state) => (
        state.usualWorkouts[workoutGroup.id] ?? <UsualWorkout>[],
        state.workoutWeightUnit,
        state.expandNutritionByDefault,
      ),
      builder: (context, selected) {
        final (usualWorkouts, weightUnit, expandedByDefault) = selected;
        return ListView(
          padding: EdgeInsets.all(AppDesign.spacing.lg),
          children: [
            if (usualWorkouts.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppDesign.spacing.xxl),
                child: Text(
                  'No usual ${workoutGroup.name.toLowerCase()} workouts yet.\n'
                  'Tap the + button to add one.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              for (final usualWorkout in usualWorkouts)
                Card(
                  key: ValueKey(usualWorkout.id),
                  margin: EdgeInsets.only(bottom: AppDesign.spacing.sm),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppDesign.spacing.md,
                      AppDesign.spacing.sm,
                      AppDesign.spacing.sm,
                      AppDesign.spacing.md,
                    ),
                    child: ExpandableWorkout(
                      name: usualWorkout.name,
                      type: usualWorkout.type,
                      sets: usualWorkout.sets,
                      duration: usualWorkout.duration ?? Duration.zero,
                      weightUnit: weightUnit,
                      expandedByDefault: expandedByDefault,
                      onNameChanged: (name) => getIt<UserSettingsBloc>().add(
                        UserSettingsEvent.usualWorkoutRenamed(
                          workoutGroup.id,
                          usualWorkout.id,
                          name,
                        ),
                      ),
                      onChanged: (sets) => getIt<UserSettingsBloc>().add(
                        UserSettingsEvent.usualWorkoutSetsChanged(
                          workoutGroup.id,
                          usualWorkout.id,
                          sets,
                        ),
                      ),
                      onDurationChanged: (duration) =>
                          getIt<UserSettingsBloc>().add(
                            UserSettingsEvent.usualWorkoutDurationChanged(
                              workoutGroup.id,
                              usualWorkout.id,
                              duration,
                            ),
                          ),
                      onRemoved: () async {
                        final confirmed = await ConfirmDialog.show(
                          context,
                          title: 'Delete usual workout?',
                          message:
                              'This permanently deletes '
                              '"${usualWorkout.name}". '
                              'Days you already logged it on are unaffected.',
                          confirmLabel: 'Delete',
                          isDestructive: true,
                        );
                        if (!confirmed) return;
                        getIt<UserSettingsBloc>().add(
                          UserSettingsEvent.usualWorkoutRemoved(
                            workoutGroup.id,
                            usualWorkout.id,
                          ),
                        );
                      },
                    ),
                  ),
                ),
            // Clears the floating action button so the last card isn't hidden
            // behind it.
            const SizedBox(height: kFloatingActionButtonMargin + 56),
          ],
        );
      },
    );
  }
}
