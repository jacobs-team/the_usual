import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template usual_workouts_view}
/// Manages the user's usual workouts library: one tab per workout group with
/// the saved workouts, editable in place, and an action to add more.
/// {@endtemplate}
class UsualWorkoutsView extends StatelessWidget {
  /// {@macro usual_workouts_view}
  const UsualWorkoutsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      UserSettingsBloc,
      UserSettingsState,
      List<WorkoutGroup>
    >(
      bloc: getIt<UserSettingsBloc>(),
      selector: (state) =>
          [...state.workoutGroups]..sort((a, b) => a.order.compareTo(b.order)),
      builder: (context, workoutGroups) {
        return DefaultTabController(
          // Rebuild the controller when groups are added, removed, or reordered
          // so the tab count and order stay in sync.
          key: ValueKey(workoutGroups.map((group) => group.id).join(',')),
          length: workoutGroups.length,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Your usual workouts'),
              leading: BackButton(onPressed: () => context.pop()),
              bottom: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [
                  for (final workoutGroup in workoutGroups)
                    BlocSelector<UserSettingsBloc, UserSettingsState, int>(
                      bloc: getIt<UserSettingsBloc>(),
                      selector: (state) =>
                          state.usualWorkouts[workoutGroup.id]?.length ?? 0,
                      builder: (context, count) {
                        return Tab(text: '${workoutGroup.name} ($count)');
                      },
                    ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                for (final workoutGroup in workoutGroups)
                  UsualWorkoutList(workoutGroup: workoutGroup),
              ],
            ),
            // A Builder gives a context under the DefaultTabController so it
            // can read the active tab and add to that group.
            floatingActionButton: Builder(
              builder: (context) {
                return FloatingActionButton(
                  tooltip: 'Add a usual workout',
                  onPressed: () async {
                    if (workoutGroups.isEmpty) return;
                    final activeTabIndex = DefaultTabController.of(
                      context,
                    ).index;
                    final workoutGroup = workoutGroups[activeTabIndex];
                    final userSettings = getIt<UserSettingsBloc>().state;
                    final weightUnit = userSettings.workoutWeightUnit;
                    final latestWeight =
                        getIt<DailyLogBloc>().state.latestWeight;
                    double? bodyWeight;
                    if (latestWeight != null) {
                      bodyWeight = weightUnit.convertFrom(
                        latestWeight.weight,
                        latestWeight.weightUnit,
                      );
                    } else if (userSettings.startingWeight != null) {
                      bodyWeight = weightUnit.convertFrom(
                        userSettings.startingWeight!,
                        userSettings.weightUnit,
                      );
                    }
                    final result =
                        await TheUsualBottomSheet.show<WorkoutEntryResult>(
                          context,
                          builder: (_) => WorkoutEntrySheet(
                            title: 'Add to ${workoutGroup.name}',
                            confirmLabel: 'Add',
                            weightUnit: weightUnit,
                            bodyWeight: bodyWeight,
                            initialType: WorkoutType.defaultForGroupName(
                              workoutGroup.name,
                            ),
                          ),
                        );
                    if (result == null) return;
                    getIt<UserSettingsBloc>().add(
                      UserSettingsEvent.usualWorkoutAdded(
                        workoutGroup.id,
                        result.name,
                        result.sets,
                        type: result.type,
                        duration: result.duration,
                      ),
                    );
                  },
                  child: const Icon(Icons.add),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
