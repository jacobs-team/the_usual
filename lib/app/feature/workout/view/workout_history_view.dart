import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template workout_history_view}
/// Workout history browsed a month at a time. A horizontal strip selects the
/// month; swiping the page flips between months. Each month lists its days,
/// and each day expands to show its workouts grouped by training group.
/// {@endtemplate}
class WorkoutHistoryView extends StatefulWidget {
  /// {@macro workout_history_view}
  const WorkoutHistoryView({super.key});

  @override
  State<WorkoutHistoryView> createState() => _WorkoutHistoryViewState();
}

class _WorkoutHistoryViewState extends State<WorkoutHistoryView> {
  final WorkoutLogBloc _workoutLogBloc = getIt<WorkoutLogBloc>();
  late DateTime _selectedMonth;
  late final PageController _pageController;

  /// One scroll controller per month, by month, so tapping a volume bar can
  /// scroll that month's list to the tapped day.
  final Map<DateTime, ItemScrollController> _monthScrollControllers = {};

  /// One expansion controller per day card, by logical day, so a day can be
  /// expanded once scrolled into view.
  final Map<DateTime, ExpansibleController> _dayExpansionControllers = {};

  @override
  void initState() {
    super.initState();
    final dayStart = getIt<UserSettingsBloc>().state.dayStartTime;
    final history = _workoutLogBloc.state.historyByMonth(dayStart);
    final initialIndex = history.isEmpty ? 0 : history.length - 1;
    final now = clock.now();
    _selectedMonth = history.isEmpty
        ? DateTime(now.year, now.month)
        : history[initialIndex].month;
    _pageController = PageController(initialPage: initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Snaps the selection to the nearest still-present month after the selected
  /// one is deleted.
  void _clampToAvailableMonth(List<WorkoutHistoryMonth> history) {
    if (!mounted || history.isEmpty) return;
    final currentPage = _pageController.hasClients
        ? (_pageController.page ?? _pageController.initialPage.toDouble())
        : 0.0;
    final targetIndex = currentPage.round().clamp(0, history.length - 1);
    setState(() => _selectedMonth = history[targetIndex].month);
    if (_pageController.hasClients) {
      _pageController.jumpToPage(targetIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TheUsualAppBar(title: 'History'),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<WorkoutLogBloc, WorkoutLogState>(
          bloc: _workoutLogBloc,
          builder: (context, state) {
            final dayStart = getIt<UserSettingsBloc>().state.dayStartTime;
            final history = state.historyByMonth(dayStart);
            if (history.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(AppDesign.spacing.xl),
                  child: Text(
                    'No workout history yet. Log a workout and it shows up '
                    'here.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            }

            final selectedMonthExists = history.any(
              (workoutHistoryMonth) => DateUtils.isSameMonth(
                workoutHistoryMonth.month,
                _selectedMonth,
              ),
            );
            if (!selectedMonthExists) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => _clampToAvailableMonth(history),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _WorkoutMonthSelector(
                  history: history,
                  selectedMonth: _selectedMonth,
                  onMonthSelected: (index) => _pageController.animateToPage(
                    index,
                    duration: AppDesign.durations.fast,
                    curve: Curves.easeOut,
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: history.length,
                    onPageChanged: (index) => setState(
                      () => _selectedMonth = history[index].month,
                    ),
                    itemBuilder: (context, monthIndex) {
                      final workoutHistoryMonth = history[monthIndex];
                      final localizations = MaterialLocalizations.of(context);
                      final itemScrollController = _monthScrollControllers
                          .putIfAbsent(
                            workoutHistoryMonth.month,
                            ItemScrollController.new,
                          );

                      // Scrolls the tapped day's card into view, then expands
                      // it once built. The chart and month label are the list's
                      // first item, so day cards are offset by one.
                      void scrollToDay(WorkoutHistoryDay workoutHistoryDay) {
                        final dayIndex = workoutHistoryMonth.days.indexOf(
                          workoutHistoryDay,
                        );
                        if (dayIndex < 0) return;
                        unawaited(
                          itemScrollController
                              .scrollTo(
                                index: dayIndex + 1,
                                duration: AppDesign.durations.fast,
                                curve: Curves.easeOut,
                              )
                              .then((_) {
                                if (!mounted) return;
                                final expansionController =
                                    _dayExpansionControllers[
                                        workoutHistoryDay.day];
                                if (expansionController != null &&
                                    !expansionController.isExpanded) {
                                  expansionController.expand();
                                }
                              }),
                        );
                      }

                      return BlocSelector<
                        UserSettingsBloc,
                        UserSettingsState,
                        (WeightUnit, List<WorkoutGroup>)
                      >(
                        bloc: getIt<UserSettingsBloc>(),
                        selector: (state) => (
                          state.workoutWeightUnit,
                          state.workoutGroups,
                        ),
                        builder: (context, settingsSelected) {
                          final (workoutWeightUnit, workoutGroups) =
                              settingsSelected;
                          return ScrollablePositionedList.builder(
                            itemScrollController: itemScrollController,
                            itemCount: workoutHistoryMonth.days.length + 1,
                            padding:
                                EdgeInsets.fromLTRB(
                                  AppDesign.spacing.lg,
                                  AppDesign.spacing.sm,
                                  AppDesign.spacing.lg,
                                  AppDesign.spacing.xl,
                                ) +
                                EdgeInsets.only(
                                  bottom: MediaQuery.paddingOf(context).bottom,
                                ),
                            itemBuilder: (context, itemIndex) {
                              if (itemIndex == 0) {
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    WorkoutVolumeChart(
                                      monthHistory: workoutHistoryMonth,
                                      weightUnit: workoutWeightUnit,
                                      onDayTapped: scrollToDay,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        bottom: AppDesign.spacing.sm,
                                      ),
                                      child: SectionLabel(
                                        localizations
                                            .formatMonthYear(
                                              workoutHistoryMonth.month,
                                            )
                                            .toUpperCase(),
                                      ),
                                    ),
                                  ],
                                );
                              }

                              final workoutHistoryDay =
                                  workoutHistoryMonth.days[itemIndex - 1];
                              return _WorkoutHistoryDayCard(
                                controller: _dayExpansionControllers
                                    .putIfAbsent(
                                      workoutHistoryDay.day,
                                      ExpansibleController.new,
                                    ),
                                workoutHistoryDay: workoutHistoryDay,
                                workoutWeightUnit: workoutWeightUnit,
                                workoutGroups: workoutGroups,
                              );
                            },
                          );
                        },
                      );
                    },
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

/// The horizontal strip of month abbreviation chips above the history pages.
class _WorkoutMonthSelector extends StatefulWidget {
  const _WorkoutMonthSelector({
    required this.history,
    required this.selectedMonth,
    required this.onMonthSelected,
  });

  final List<WorkoutHistoryMonth> history;
  final DateTime selectedMonth;
  final ValueChanged<int> onMonthSelected;

  @override
  State<_WorkoutMonthSelector> createState() => _WorkoutMonthSelectorState();
}

class _WorkoutMonthSelectorState extends State<_WorkoutMonthSelector> {
  final GlobalKey<State<StatefulWidget>> _selectedChipKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _revealSelected());
  }

  @override
  void didUpdateWidget(_WorkoutMonthSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedMonth != widget.selectedMonth) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _revealSelected());
    }
  }

  void _revealSelected() {
    final selectedContext = _selectedChipKey.currentContext;
    if (selectedContext == null) return;
    unawaited(
      Scrollable.ensureVisible(
        selectedContext,
        alignment: 0.5,
        duration: AppDesign.durations.fast,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
        horizontal: AppDesign.spacing.lg,
        vertical: AppDesign.spacing.md,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < widget.history.length; index++)
            Builder(
              builder: (context) {
                final workoutHistoryMonth = widget.history[index];
                final monthName = localizations
                    .formatMonthYear(workoutHistoryMonth.month)
                    .split(' ')
                    .first;
                final abbreviation = monthName
                    .substring(0, monthName.length < 3 ? monthName.length : 3)
                    .toUpperCase();
                final isSelected = DateUtils.isSameMonth(
                  workoutHistoryMonth.month,
                  widget.selectedMonth,
                );
                return Padding(
                  padding: EdgeInsets.only(
                    right: index == widget.history.length - 1
                        ? 0
                        : AppDesign.spacing.sm,
                  ),
                  child: _WorkoutMonthChip(
                    key: isSelected ? _selectedChipKey : null,
                    label: abbreviation,
                    isSelected: isSelected,
                    onTap: () => widget.onMonthSelected(index),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

/// A single month chip: its abbreviation only, no weigh-in subtitle.
class _WorkoutMonthChip extends StatelessWidget {
  const _WorkoutMonthChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foregroundColor = isSelected
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface;

    return Material(
      color: isSelected
          ? theme.colorScheme.primary
          : theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(AppDesign.radius.md),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDesign.spacing.md,
            vertical: AppDesign.spacing.sm,
          ),
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

/// A single day in the workout history list: a summary that expands to show
/// the day's workouts grouped by training group.
class _WorkoutHistoryDayCard extends StatelessWidget {
  const _WorkoutHistoryDayCard({
    required this.workoutHistoryDay,
    required this.workoutWeightUnit,
    required this.workoutGroups,
    this.controller,
  });

  final WorkoutHistoryDay workoutHistoryDay;
  final WeightUnit workoutWeightUnit;
  final List<WorkoutGroup> workoutGroups;

  /// Drives the card's expansion so tapping its volume bar can open it once
  /// scrolled into view.
  final ExpansibleController? controller;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final sortedGroups = [...workoutGroups]
      ..sort((a, b) => a.order.compareTo(b.order));
    final entriesByGroupId = <String, List<WorkoutLogEntry>>{};
    for (final workoutLogEntry in workoutHistoryDay.workoutEntries) {
      (entriesByGroupId[workoutLogEntry.workoutGroupId] ??= [])
          .add(workoutLogEntry);
    }

    final knownGroupIds = {
      for (final workoutGroup in sortedGroups) workoutGroup.id,
    };
    final otherEntries = workoutHistoryDay.workoutEntries
        .where(
          (workoutLogEntry) => !knownGroupIds.contains(
            workoutLogEntry.workoutGroupId,
          ),
        )
        .toList();

    return Card(
      margin: EdgeInsets.only(bottom: AppDesign.spacing.sm),
      child: ExpansionTile(
        controller: controller,
        shape: const Border(),
        tilePadding: EdgeInsets.symmetric(horizontal: AppDesign.spacing.md),
        title: Text(localizations.formatMediumDate(workoutHistoryDay.day)),
        subtitle: Text(
          '${workoutHistoryDay.volume.trimmedDecimal} '
          '${workoutWeightUnit.name}',
        ),
        childrenPadding: EdgeInsets.fromLTRB(
          AppDesign.spacing.md,
          0,
          AppDesign.spacing.md,
          AppDesign.spacing.md,
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final workoutGroup in sortedGroups) ...[
            if ((entriesByGroupId[workoutGroup.id] ?? const []).isNotEmpty) ...[
              SectionLabel(workoutGroup.name.toUpperCase()),
              for (final workoutLogEntry
                  in entriesByGroupId[workoutGroup.id]!)
                LoggedWorkoutRow(
                  key: ValueKey(workoutLogEntry.id),
                  workoutLogEntry: workoutLogEntry,
                  weightUnit: workoutWeightUnit,
                  expandedByDefault: false,
                ),
            ],
          ],
          if (otherEntries.isNotEmpty) ...[
            const SectionLabel('OTHER'),
            for (final workoutLogEntry in otherEntries)
              LoggedWorkoutRow(
                key: ValueKey(workoutLogEntry.id),
                workoutLogEntry: workoutLogEntry,
                weightUnit: workoutWeightUnit,
                expandedByDefault: false,
              ),
          ],
        ],
      ),
    );
  }
}
