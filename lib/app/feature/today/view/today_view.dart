import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template today_view}
/// The Today view: tracks the day's weight and logs the day's meals from the
/// user's usuals, with a running calorie total.
/// {@endtemplate}
class TodayView extends StatefulWidget {
  /// {@macro today_view}
  const TodayView({super.key});

  @override
  State<TodayView> createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> with WidgetsBindingObserver {
  Timer? _refreshTimer;

  /// The day(s) the view shows and logs onto. Null is the live "today" view:
  /// it follows the clock and stamps entries at the current time. A non-null
  /// range is a specific single day (start == end) or a multi-day span the
  /// user picked, whose logs fan across every day in it.
  DateTimeRange? _selectedRange;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scheduleNextRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // The app may have been backgrounded across a meal boundary or midnight;
    // rebuild and reschedule against the current time on resume.
    if (state == AppLifecycleState.resumed) {
      setState(() {});
      _scheduleNextRefresh();
    }
  }

  /// Rebuilds when the highlighted meal next changes — its reminder time, or
  /// the time-of-day boundary — so it stays current while the app is open.
  void _scheduleNextRefresh() {
    final now = clock.now();
    final next = getIt<UserSettingsBloc>().state.nextMealBoundary(now);
    _refreshTimer?.cancel();
    _refreshTimer = Timer(next.difference(now), () {
      if (!mounted) return;
      setState(() {});
      _scheduleNextRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = clock.now();
    final currentMeal = getIt<UserSettingsBloc>().state.currentMeal(now);

    final selectedRange = _selectedRange;
    final today = now.logicalDay(getIt<UserSettingsBloc>().state.dayStartTime);
    final pillLabel = _pillLabel(selectedRange);

    return Scaffold(
      appBar: TheUsualAppBar(
        title: 'Today',
        historyRoute: Routes.history,
        titleWidget: FilledButton(
          key: const Key('today-date-pill'),
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
                  Map<MealOfTheDay, List<UsualMeal>>,
                  bool,
                  List<CalorieGoalEntry>,
                  TimeOfDay,
                )
              >(
                bloc: getIt<UserSettingsBloc>(),
                selector: (state) => (
                  state.usuals,
                  state.expandNutritionByDefault,
                  state.calorieGoalHistory,
                  state.dayStartTime,
                ),
                builder: (context, selected) {
                  final (
                    usualMeals,
                    expandNutritionByDefault,
                    calorieGoalHistory,
                    dayStartTime,
                  ) = selected;
                  final today = now.logicalDay(dayStartTime);
                  final selectedRange = _selectedRange;
                  final isToday = selectedRange == null;
                  final displayDay = selectedRange == null
                      ? today
                      : DateUtils.dateOnly(selectedRange.start);
                  // The bar shows the goal active on the day being viewed, not
                  // today's, so a past day keeps the goal it had then.
                  final calorieGoal = calorieGoalHistory.goalOn(displayDay);
                  final logDays = selectedRange?.logicalDays;
                  final logDayStart = selectedRange == null
                      ? null
                      : dayStartTime;
                  return BlocSelector<
                    DailyLogBloc,
                    DailyLogState,
                    List<MealLogEntry>
                  >(
                    bloc: getIt<DailyLogBloc>(),
                    selector: (state) => state.mealEntries,
                    builder: (context, mealEntries) {
                      final breakdown = mealEntries.breakdownOn(
                        displayDay,
                        dayStartTime,
                      );
                      return CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.fromLTRB(
                              AppDesign.spacing.lg,
                              AppDesign.spacing.lg,
                              AppDesign.spacing.lg,
                              AppDesign.spacing.md,
                            ),
                            sliver: SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _WeightTracker(days: logDays ?? [today]),
                                  SizedBox(height: AppDesign.spacing.lg),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: NutritionBar(
                                          nutrition: breakdown.nutrition,
                                          calorieGoal: calorieGoal,
                                          onSetGoal: () => context.push(
                                            '${Routes.settings}?focus=goals',
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: AppDesign.spacing.sm),
                                      _NutritionExpansionToggle(
                                        expanded: expandNutritionByDefault,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          for (final mealOfTheDay in MealOfTheDay.values)
                            MealLogSection(
                              mealOfTheDay: mealOfTheDay,
                              mealLogEntries:
                                  breakdown.entriesByMeal[mealOfTheDay] ??
                                  const <MealLogEntry>[],
                              quickPicks: mealEntries.orderedQuickPicks(
                                mealOfTheDay: mealOfTheDay,
                                usuals: usualMeals,
                                day: displayDay,
                                dayStart: dayStartTime,
                              ),
                              otherMealUsuals: mealEntries.usualsFromOtherMeals(
                                mealOfTheDay: mealOfTheDay,
                                usuals: usualMeals,
                                day: displayDay,
                                dayStart: dayStartTime,
                              ),
                              isCurrent: isToday && mealOfTheDay == currentMeal,
                              nutritionExpandedByDefault:
                                  expandNutritionByDefault,
                              logDays: logDays,
                              dayStart: logDayStart,
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

  /// The pill's label: "Today" for the live view, a single formatted date for
  /// one selected day, or a "start – end" span for a range.
  String _pillLabel(DateTimeRange? selectedRange) {
    if (selectedRange == null) return 'Today';
    final currentYear = clock.now().year;
    // Drop the year for dates in the current year to keep the pill compact,
    // but show it for other years so an off-year date isn't ambiguous.
    String formatDate(DateTime date) =>
        (date.year == currentYear ? DateFormat.MMMd() : DateFormat.yMMMd())
            .format(date);
    final startLabel = formatDate(selectedRange.start);
    if (DateUtils.isSameDay(selectedRange.start, selectedRange.end)) {
      return startLabel;
    }
    // The day picker only ever selects a single day (start == end), so the
    // span label is unreachable today; kept for when range selection lands.
    final rangeLabel = '$startLabel – ${formatDate(selectedRange.end)}';
    return rangeLabel; // coverage:ignore-line
  }
}

/// Toggles whether every meal's nutrition starts expanded, swapping between
/// the expand and collapse icons with a short animation as the setting flips.
class _NutritionExpansionToggle extends StatelessWidget {
  const _NutritionExpansionToggle({required this.expanded});

  /// Whether nutrition currently starts expanded.
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    // Sized to the bar's height so it sits centered against it when the row is
    // bottom-aligned, rather than against the taller nutrition column.
    return SizedBox(
      height: NutritionBar.height,
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 40),
        tooltip: expanded ? 'Minimize nutrition' : 'Expand nutrition',
        onPressed: () => getIt<UserSettingsBloc>().add(
          UserSettingsEvent.expandNutritionByDefaultChanged(
            expandNutritionByDefault: !expanded,
          ),
        ),
        icon: AnimatedSwitcher(
          duration: AppDesign.durations.fast,
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Icon(
            expanded ? Icons.unfold_less : Icons.unfold_more,
            key: ValueKey(expanded),
          ),
        ),
      ),
    );
  }
}

/// A trailing window over which the weight tracker reports the net change.
enum _WeightTrendRange {
  sevenDays(Duration(days: 7), '7d', 'Last 7 days'),
  thirtyDays(Duration(days: 30), '30d', 'Last 30 days'),
  ninetyDays(Duration(days: 90), '90d', 'Last 90 days'),
  year(Duration(days: 365), '1y', 'Last year');

  const _WeightTrendRange(this.window, this.shortLabel, this.menuLabel);

  /// The span of time the change is measured across.
  final Duration window;

  /// Compact label shown on the inline range selector, e.g. "30d".
  final String shortLabel;

  /// Full label shown in the range selector's menu, e.g. "Last 30 days".
  final String menuLabel;
}

/// Today's weight tracker: an inline field for the day's weigh-in, prefilled
/// with the last recorded weight as a hint, with the net change over a
/// selectable trailing window shown beside the label.
class _WeightTracker extends StatefulWidget {
  const _WeightTracker({required this.days});

  /// The days whose weigh-in this field records. One day in the live/single-day
  /// view; every day in a selected range.
  final List<DateTime> days;

  @override
  State<_WeightTracker> createState() => _WeightTrackerState();
}

class _WeightTrackerState extends State<_WeightTracker> {
  _WeightTrendRange _range = _WeightTrendRange.thirtyDays;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dayStart = getIt<UserSettingsBloc>().state.dayStartTime;
    final displayDay = widget.days.first;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppDesign.spacing.md),
        child: Row(
          children: [
            Icon(
              Icons.monitor_weight_outlined,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: AppDesign.spacing.sm),
            Text('Weight', style: theme.textTheme.bodyMedium),
            SizedBox(width: AppDesign.spacing.sm),
            BlocSelector<DailyLogBloc, DailyLogState, (double?, bool)>(
              bloc: getIt<DailyLogBloc>(),
              selector: (state) => (
                state.weightChangeOver(_range.window, displayDay, dayStart),
                state.weightEntries.length >= 2,
              ),
              builder: (context, selected) {
                final (change, hasHistory) = selected;
                if (!hasHistory) return const SizedBox.shrink();
                return _WeightTrend(
                  change: change,
                  range: _range,
                  onRangeSelected: (range) => setState(() => _range = range),
                );
              },
            ),
            const Spacer(),
            WeightEntryField(days: widget.days, showLastWeightButton: true),
          ],
        ),
      ),
    );
  }
}

/// The net weight [change] over [range], shown as a direction arrow and amount,
/// next to a tappable selector that switches the range. A null [change] means
/// the window has too few weigh-ins to measure one.
class _WeightTrend extends StatelessWidget {
  const _WeightTrend({
    required this.change,
    required this.range,
    required this.onRangeSelected,
  });

  final double? change;
  final _WeightTrendRange range;
  final ValueChanged<_WeightTrendRange> onRangeSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium;
    final iconColor = theme.colorScheme.onSurface;
    final weightUnit = getIt<UserSettingsBloc>().state.weightUnit;

    final change = this.change;
    final Widget delta;
    if (change == null) {
      delta = Text('—', style: textStyle);
    } else if (change == 0) {
      delta = Text('No change', style: textStyle);
    } else {
      final amount = '${change.abs().trimmedDecimal} ${weightUnit.name}';
      delta = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            change > 0 ? Icons.arrow_upward : Icons.arrow_downward,
            size: 14,
            color: iconColor,
          ),
          SizedBox(width: AppDesign.spacing.xs),
          Text(amount, style: textStyle),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        delta,
        SizedBox(width: AppDesign.spacing.sm),
        PopupMenuButton<_WeightTrendRange>(
          initialValue: range,
          tooltip: 'Change range',
          onSelected: onRangeSelected,
          itemBuilder: (context) => [
            for (final trendRange in _WeightTrendRange.values)
              PopupMenuItem(
                value: trendRange,
                child: Text(trendRange.menuLabel),
              ),
          ],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(range.shortLabel, style: textStyle),
              Icon(Icons.arrow_drop_down, size: 18, color: iconColor),
            ],
          ),
        ),
      ],
    );
  }
}
