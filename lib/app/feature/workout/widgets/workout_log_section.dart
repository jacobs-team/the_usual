import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template workout_log_section}
/// One workout group's slice of the Workouts view: what's been logged for it
/// so far, quick-pick chips for the user's usuals not yet logged, and an entry
/// point for logging a new workout. Builds as a sliver for a [CustomScrollView].
/// {@endtemplate}
class WorkoutLogSection extends StatelessWidget {
  /// {@macro workout_log_section}
  const WorkoutLogSection({
    required this.workoutGroup,
    required this.workoutLogEntries,
    required this.quickPicks,
    required this.weightUnit,
    required this.expandedByDefault,
    required this.onRenamed,
    required this.onDeleteRequested,
    this.justLoggedWorkoutId,
    this.logDays,
    this.dayStart,
    super.key,
  });

  /// The workout group this section represents.
  final WorkoutGroup workoutGroup;

  /// Entries already logged for this group today.
  final List<WorkoutLogEntry> workoutLogEntries;

  /// The user's usuals offered as quick picks, already filtered to those not
  /// yet logged today.
  final List<UsualWorkout> quickPicks;

  /// The weight unit shown in set fields and the section volume.
  final WeightUnit weightUnit;

  /// Whether each logged entry's set fields start expanded for editing.
  final bool expandedByDefault;

  /// Called with the trimmed new name when the user renames the group.
  final ValueChanged<String> onRenamed;

  /// Called when the user taps the delete button.
  final VoidCallback onDeleteRequested;

  /// The most-recently-logged entry's id. Its row opens regardless of
  /// [expandedByDefault] so the user can adjust the sets right after logging.
  final String? justLoggedWorkoutId;

  /// The days workouts logged from this section are recorded onto. Null logs
  /// to today (stamped at the current time); a list logs onto each day.
  final List<DateTime>? logDays;

  /// The user's day-start, used with [logDays] to stamp entries onto each day.
  final TimeOfDay? dayStart;

  void _logOntoTargetDays(
    String name,
    List<WorkoutSet> sets, {
    String? usualWorkoutId,
  }) {
    final targetDays = logDays;
    final workoutLogBloc = getIt<WorkoutLogBloc>();
    if (targetDays == null) {
      workoutLogBloc.add(
        WorkoutLogEvent.workoutLogged(
          workoutGroup.id,
          name,
          sets: sets,
          usualWorkoutId: usualWorkoutId,
        ),
      );
      return;
    }
    for (final day in targetDays) {
      workoutLogBloc.add(
        WorkoutLogEvent.workoutLogged(
          workoutGroup.id,
          name,
          sets: sets,
          usualWorkoutId: usualWorkoutId,
          day: day,
          dayStart: dayStart,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalVolume = workoutLogEntries.totalVolume;

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        AppDesign.spacing.lg,
        0,
        AppDesign.spacing.lg,
        AppDesign.spacing.md,
      ),
      sliver: DecoratedSliver(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppDesign.radius.md),
          border: Border.all(color: theme.colorScheme.outline),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        sliver: SliverPadding(
          padding: EdgeInsets.all(AppDesign.spacing.md),
          sliver: SliverMainAxisGroup(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: AppDesign.spacing.sm),
                  child: Row(
                    children: [
                      Expanded(
                        child: _EditableGroupName(
                          key: Key('group-name-${workoutGroup.id}'),
                          name: workoutGroup.name,
                          onRenamed: onRenamed,
                        ),
                      ),
                      if (workoutLogEntries.isNotEmpty)
                        Text(
                          '${totalVolume.trimmedDecimal} ${weightUnit.name}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete_forever_outlined),
                        onPressed: onDeleteRequested,
                      ),
                    ],
                  ),
                ),
              ),
              SliverList.builder(
                itemCount: workoutLogEntries.length,
                itemBuilder: (context, index) {
                  final workoutLogEntry = workoutLogEntries[index];
                  final justLogged =
                      workoutLogEntry.id == justLoggedWorkoutId;
                  return LoggedWorkoutRow(
                    key: ValueKey(workoutLogEntry.id),
                    workoutLogEntry: workoutLogEntry,
                    weightUnit: weightUnit,
                    expandedByDefault: expandedByDefault || justLogged,
                  );
                },
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (quickPicks.isNotEmpty) ...[
                      SizedBox(height: AppDesign.spacing.md),
                      Wrap(
                        spacing: AppDesign.spacing.sm,
                        runSpacing: AppDesign.spacing.sm,
                        children: [
                          for (final usualWorkout in quickPicks)
                            _QuickPickChip(
                              label: '+ ${usualWorkout.name}',
                              onPressed: () => _logOntoTargetDays(
                                usualWorkout.name,
                                usualWorkout.sets,
                                usualWorkoutId: usualWorkout.id,
                              ),
                              onRemove: () =>
                                  getIt<UserSettingsBloc>().add(
                                    UserSettingsEvent.usualWorkoutRemoved(
                                      workoutGroup.id,
                                      usualWorkout.id,
                                    ),
                                  ),
                            ),
                        ],
                      ),
                    ],
                    SizedBox(height: AppDesign.spacing.sm),
                    Wrap(
                      spacing: AppDesign.spacing.sm,
                      children: [
                        TextButton.icon(
                          onPressed: () async {
                            final latestWeight =
                                getIt<DailyLogBloc>().state.latestWeight;
                            final userSettings =
                                getIt<UserSettingsBloc>().state;
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
                            final result = await TheUsualBottomSheet
                                .show<WorkoutEntryResult>(
                                  context,
                                  builder: (_) => WorkoutEntrySheet(
                                    title: 'New workout',
                                    confirmLabel: 'Log',
                                    weightUnit: weightUnit,
                                    showAddToUsuals: true,
                                    bodyWeight: bodyWeight,
                                  ),
                                );
                            if (result == null) return;
                            if (result.addToUsuals) {
                              getIt<UserSettingsBloc>().add(
                                UserSettingsEvent.usualWorkoutAdded(
                                  workoutGroup.id,
                                  result.name,
                                  result.sets,
                                ),
                              );
                            }
                            _logOntoTargetDays(result.name, result.sets);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('New workout'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditableGroupName extends StatefulWidget {
  const _EditableGroupName({
    required this.name,
    required this.onRenamed,
    super.key,
  });

  final String name;
  final ValueChanged<String> onRenamed;

  @override
  State<_EditableGroupName> createState() => _EditableGroupNameState();
}

class _EditableGroupNameState extends State<_EditableGroupName> {
  late final _controller = TextEditingController(text: widget.name);
  late final _focusNode = FocusNode();
  var _editing = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_EditableGroupName oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_editing &&
        widget.name != oldWidget.name &&
        _controller.text != widget.name) {
      _controller.text = widget.name;
    }
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _editing) {
      _commit(_controller.text);
    }
  }

  void _commit(String value) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty && trimmed != widget.name) {
      widget.onRenamed(trimmed);
    } else {
      _controller.text = widget.name;
    }
    setState(() => _editing = false);
  }

  void _startEditing() {
    setState(() => _editing = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_editing) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TheUsualTextField(
          controller: _controller,
          focusNode: _focusNode,
          dense: true,
          autoSize: true,
          textCapitalization: TextCapitalization.sentences,
          onSubmitted: _commit,
        ),
      );
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              widget.name,
              style: theme.textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 16),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            onPressed: _startEditing,
          ),
        ],
      ),
    );
  }
}

/// A quick pick for a usual workout not yet logged today.
class _QuickPickChip extends StatelessWidget {
  const _QuickPickChip({
    required this.label,
    required this.onPressed,
    required this.onRemove,
  });

  final String label;
  final VoidCallback onPressed;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(AppDesign.radius.lg);

    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(Icons.delete_outline),
          onPressed: onRemove,
          child: const Text('Remove from usuals'),
        ),
      ],
      builder: (context, controller, child) {
        return DashedBorder(
          color: theme.colorScheme.outlineVariant,
          radius: AppDesign.radius.lg,
          child: Material(
            borderRadius: borderRadius,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              onLongPress: controller.open,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDesign.spacing.md,
                  vertical: AppDesign.spacing.sm,
                ),
                child: Text(label, style: theme.textTheme.labelLarge),
              ),
            ),
          ),
        );
      },
    );
  }
}
