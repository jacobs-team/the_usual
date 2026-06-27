import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template expandable_workout}
/// A workout exercise name with its sets in an [ExpansionTile]: collapsed it
/// shows a read-only summary line, expanded it reveals editable [SetFields].
/// The leading chevron animates and a trailing button removes the entry. Starts
/// in [expandedByDefault] and follows that value when it changes, while keeping
/// any manual toggle in between.
/// {@endtemplate}
class ExpandableWorkout extends StatefulWidget {
  /// {@macro expandable_workout}
  const ExpandableWorkout({
    required this.name,
    required this.sets,
    required this.weightUnit,
    required this.expandedByDefault,
    required this.onChanged,
    required this.onRemoved,
    this.type = WorkoutType.strength,
    this.duration = Duration.zero,
    this.onDurationChanged,
    this.onNameChanged,
    this.expandedFooter,
    super.key,
  });

  /// The exercise name.
  final String name;

  /// The kind of exercise: strength shows its sets, cardio shows its duration.
  final WorkoutType type;

  /// The sets to summarize when collapsed and seed the fields when open, for a
  /// strength exercise.
  final List<WorkoutSet> sets;

  /// The duration to summarize when collapsed and seed the field when open, for
  /// a cardio exercise.
  final Duration duration;

  /// The weight unit shown in set fields.
  final WeightUnit weightUnit;

  /// Whether the fields start expanded for editing.
  final bool expandedByDefault;

  /// Called with the updated sets whenever a set field changes.
  final ValueChanged<List<WorkoutSet>> onChanged;

  /// Called with the updated duration whenever the time field changes.
  final ValueChanged<Duration>? onDurationChanged;

  /// Called when the remove button is pressed.
  final VoidCallback onRemoved;

  /// Called with the new name whenever it changes. When null the name is shown
  /// read-only; when provided it becomes an editable field.
  final ValueChanged<String>? onNameChanged;

  /// Extra content shown below the fields while expanded, e.g. a sync action.
  final Widget? expandedFooter;

  @override
  State<ExpandableWorkout> createState() => _ExpandableWorkoutState();
}

class _ExpandableWorkoutState extends State<ExpandableWorkout> {
  final _controller = ExpansibleController();
  late final _nameController = TextEditingController(text: widget.name);
  late bool _expanded = widget.expandedByDefault;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ExpandableWorkout oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reflect an externally changed name without disturbing the cursor while
    // the user is typing into the field.
    if (widget.name != oldWidget.name && _nameController.text != widget.name) {
      _nameController.text = widget.name;
    }
    // The default flipped: reflect it on the tile after this frame, since the
    // controller drives the already-built tile.
    if (widget.expandedByDefault != oldWidget.expandedByDefault) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (widget.expandedByDefault) {
          _controller.expand();
        } else {
          _controller.collapse();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = switch (widget.type) {
      WorkoutType.strength => widget.sets.summary,
      WorkoutType.cardio =>
        widget.duration == Duration.zero
            ? 'No time'
            : widget.duration.clockLabel,
    };
    return ExpansionTile(
      dense: true,
      controller: _controller,
      initiallyExpanded: widget.expandedByDefault,
      onExpansionChanged: (expanded) => setState(() => _expanded = expanded),
      controlAffinity: ListTileControlAffinity.leading,
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      shape: const Border(),
      collapsedShape: const Border(),
      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
      title: widget.onNameChanged != null
          ? LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: AppDesign.spacing.sm,
                  runSpacing: AppDesign.spacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth,
                      ),
                      child: TheUsualTextField(
                        controller: _nameController,
                        onChanged: widget.onNameChanged,
                        textCapitalization: TextCapitalization.sentences,
                        textStyle: theme.textTheme.bodyLarge,
                        dense: true,
                        autoSize: true,
                      ),
                    ),
                    if (!_expanded)
                      Text(
                        summary,
                        style: theme.textTheme.bodyMedium,
                      ),
                  ],
                );
              },
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: AppDesign.spacing.sm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth,
                      ),
                      child: Text(
                        widget.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          textBaseline: TextBaseline.alphabetic,
                        ),
                      ),
                    ),
                    if (!_expanded)
                      Text(
                        summary,
                        style: theme.textTheme.bodyMedium,
                      ),
                  ],
                );
              },
            ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_forever_outlined),
        onPressed: widget.onRemoved,
      ),
      children: [
        if (widget.type == WorkoutType.cardio) ...[
          const SectionLabel('TIME'),
          SizedBox(height: AppDesign.spacing.sm),
          TimeField(
            initial: widget.duration,
            onChanged: widget.onDurationChanged ?? (_) {},
          ),
          if (widget.expandedFooter != null) widget.expandedFooter!,
        ] else ...[
          const SectionLabel('SETS'),
          SetFields(
            dense: true,
            initial: widget.sets,
            weightUnit: widget.weightUnit,
            onChanged: widget.onChanged,
            trailing: widget.expandedFooter,
          ),
        ],
      ],
    );
  }
}
