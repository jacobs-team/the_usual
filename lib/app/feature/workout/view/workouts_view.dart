import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template workouts_view}
/// The Workouts tab: logs the day's workouts from the user's usuals, grouped
/// by training group, with a running volume total.
/// {@endtemplate}
class WorkoutsView extends StatefulWidget {
  /// {@macro workouts_view}
  const WorkoutsView({super.key});

  @override
  State<WorkoutsView> createState() => _WorkoutsViewState();
}

class _WorkoutsViewState extends State<WorkoutsView> {
  /// The day(s) the view shows and logs onto. Null is the live "today" view.
  /// A non-null range is a specific single day or multi-day span.
  DateTimeRange? _selectedRange;

  @override
  Widget build(BuildContext context) {
    final now = clock.now();
    final today = now.logicalDay(
      getIt<UserSettingsBloc>().state.dayStartTime,
    );
    final selectedRange = _selectedRange;
    final pillLabel = _pillLabel(selectedRange);

    return Scaffold(
      appBar: TheUsualAppBar(
        title: 'Workouts',
        historyRoute: Routes.workoutHistory,
        titleWidget: FilledButton(
          key: const Key('workouts-date-pill'),
          style: pillButtonStyle(context),
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              initialDate: selectedRange?.start ?? today,
            );
            if (picked == null) return;
            final pickedDay = DateUtils.dateOnly(picked);
            setState(() {
              _selectedRange = DateUtils.isSameDay(pickedDay, today)
                  ? null
                  : DateTimeRange(start: pickedDay, end: pickedDay);
            });
          },
          child: Text(pillLabel),
        ),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: SafeArea(
          bottom: false,
          child:
              BlocSelector<
                UserSettingsBloc,
                UserSettingsState,
                (
                  List<WorkoutGroup>,
                  Map<String, List<UsualWorkout>>,
                  WeightUnit,
                  bool,
                  TimeOfDay,
                )
              >(
                bloc: getIt<UserSettingsBloc>(),
                selector: (state) => (
                  state.workoutGroups,
                  state.usualWorkouts,
                  state.workoutWeightUnit,
                  state.expandNutritionByDefault,
                  state.dayStartTime,
                ),
                builder: (context, settingsSelected) {
                  final (
                    workoutGroups,
                    usualWorkouts,
                    workoutWeightUnit,
                    expandNutritionByDefault,
                    dayStartTime,
                  ) = settingsSelected;
                  final displayDay = selectedRange == null
                      ? now.logicalDay(dayStartTime)
                      : DateUtils.dateOnly(selectedRange.start);
                  final logDays = selectedRange?.logicalDays;
                  final logDayStart = selectedRange == null
                      ? null
                      : dayStartTime;

                  return BlocSelector<
                    WorkoutLogBloc,
                    WorkoutLogState,
                    List<WorkoutLogEntry>
                  >(
                    bloc: getIt<WorkoutLogBloc>(),
                    selector: (state) => state.workoutEntries,
                    builder: (context, workoutEntries) {
                      final dayEntries = workoutEntries.entriesOn(
                        displayDay,
                        dayStartTime,
                      );
                      final entriesByGroup = <String, List<WorkoutLogEntry>>{};
                      for (final workoutLogEntry in dayEntries) {
                        (entriesByGroup[workoutLogEntry.workoutGroupId] ??= [])
                            .add(workoutLogEntry);
                      }
                      final sortedGroups = [...workoutGroups]
                        ..sort(
                          (a, b) => a.order.compareTo(b.order),
                        );

                      return CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: SizedBox(height: AppDesign.spacing.lg),
                          ),
                          for (final workoutGroup in sortedGroups)
                            WorkoutLogSection(
                              workoutGroup: workoutGroup,
                              onRenamed: (name) =>
                                  getIt<UserSettingsBloc>().add(
                                    UserSettingsEvent.workoutGroupRenamed(
                                      workoutGroup.id,
                                      name,
                                    ),
                                  ),
                              onDeleteRequested: () {
                                final hasUsuals =
                                    (usualWorkouts[workoutGroup.id] ?? const [])
                                        .isNotEmpty;
                                final hasLogged = getIt<WorkoutLogBloc>()
                                    .state
                                    .workoutEntries
                                    .any(
                                      (workoutLogEntry) =>
                                          workoutLogEntry.workoutGroupId ==
                                          workoutGroup.id,
                                    );
                                if (hasUsuals || hasLogged) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Empty this group before deleting it.',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                getIt<UserSettingsBloc>().add(
                                  UserSettingsEvent.workoutGroupRemoved(
                                    workoutGroup.id,
                                  ),
                                );
                              },
                              workoutLogEntries:
                                  entriesByGroup[workoutGroup.id] ??
                                  const <WorkoutLogEntry>[],
                              previousSession: workoutEntries
                                  .previousSessionWorkouts(
                                    workoutGroupId: workoutGroup.id,
                                    day: displayDay,
                                    dayStart: dayStartTime,
                                  ),
                              quickPicks: workoutEntries.orderedQuickPicks(
                                workoutGroupId: workoutGroup.id,
                                usuals:
                                    usualWorkouts[workoutGroup.id] ??
                                    const <UsualWorkout>[],
                                day: displayDay,
                                dayStart: dayStartTime,
                              ),
                              weightUnit: workoutWeightUnit,
                              expandedByDefault: expandNutritionByDefault,
                              logDays: logDays,
                              dayStart: logDayStart,
                            ),
                          SliverPadding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDesign.spacing.md,
                            ),
                            sliver: const SliverToBoxAdapter(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: _AddGroupButton(),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: MediaQuery.paddingOf(context).bottom,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
        ),
      ),
    );
  }

  /// Swipes the shown day back (drag left→right) or forward (right→left), with
  /// today's live view in between. Unbounded, so past and future days are both
  /// reachable.
  void _onHorizontalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity;
    if (velocity == null || velocity == 0) return;
    final deltaDays = velocity > 0 ? -1 : 1;
    final today = clock.now().logicalDay(
      getIt<UserSettingsBloc>().state.dayStartTime,
    );
    setState(() {
      _selectedRange = selectedDayShifted(_selectedRange, deltaDays, today);
    });
  }

  /// The pill's label: "Today" for the live view, or a formatted date.
  String _pillLabel(DateTimeRange? selectedRange) {
    if (selectedRange == null) return 'Today';
    final currentYear = clock.now().year;
    String formatDate(DateTime date) =>
        (date.year == currentYear ? DateFormat.MMMd() : DateFormat.yMMMd())
            .format(date);
    final startLabel = formatDate(selectedRange.start);
    if (DateUtils.isSameDay(selectedRange.start, selectedRange.end)) {
      return startLabel;
    }
    final rangeLabel = '$startLabel – ${formatDate(selectedRange.end)}';
    return rangeLabel; // coverage:ignore-line
  }
}

/// Button that prompts for a name and adds a new workout group.
class _AddGroupButton extends StatelessWidget {
  const _AddGroupButton();

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      key: const Key('add-workout-group'),
      onPressed: () async {
        final nameController = TextEditingController();
        await showDialog<void>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Add group'),
            content: TheUsualTextField(
              controller: nameController,
              hintText: 'Group name',
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                key: const Key('add-group-submit'),
                onPressed: () {
                  final name = nameController.text.trim();
                  if (name.isEmpty) return;
                  Navigator.of(dialogContext).pop();
                  getIt<UserSettingsBloc>().add(
                    UserSettingsEvent.workoutGroupAdded(name),
                  );
                },
                child: const Text('Add'),
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.add),
      label: const Text('Add group'),
    );
  }
}
