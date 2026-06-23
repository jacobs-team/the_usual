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
        titleWidget: ActionChip(
          key: const Key('today-date-pill'),
          label: Text(pillLabel),
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
        ),
      ),
      body: SafeArea(
        bottom: false,
        child:
            BlocSelector<
              UserSettingsBloc,
              UserSettingsState,
              (Map<MealOfTheDay, List<UsualMeal>>, bool, int?, TimeOfDay)
            >(
              bloc: getIt<UserSettingsBloc>(),
              selector: (state) => (
                state.usuals,
                state.expandNutritionByDefault,
                state.calorieGoal,
                state.dayStartTime,
              ),
              builder: (context, selected) {
                final (
                  usualMeals,
                  expandNutritionByDefault,
                  calorieGoal,
                  dayStartTime,
                ) = selected;
                final today = now.logicalDay(dayStartTime);
                final selectedRange = _selectedRange;
                final isToday = selectedRange == null;
                final displayDay = selectedRange == null
                    ? today
                    : DateUtils.dateOnly(selectedRange.start);
                final logDays = selectedRange?.logicalDays;
                final logDayStart = selectedRange == null ? null : dayStartTime;
                return BlocSelector<
                  DailyLogBloc,
                  DailyLogState,
                  (List<MealLogEntry>, String?)
                >(
                  bloc: getIt<DailyLogBloc>(),
                  selector: (state) => (
                    state.mealEntries,
                    state.justLoggedEntryId,
                  ),
                  builder: (context, selected) {
                    final (mealEntries, justLoggedEntryId) = selected;
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
                                        onSetGoal: () => context.go(
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
                            justLoggedEntryId: justLoggedEntryId,
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
    );
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
    return '$startLabel – ${formatDate(selectedRange.end)}'; // coverage:ignore-line
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

/// Today's weight tracker: an inline field for the day's weigh-in, prefilled
/// with the last recorded weight as a hint.
class _WeightTracker extends StatelessWidget {
  const _WeightTracker({required this.days});

  /// The days whose weigh-in this field records. One day in the live/single-day
  /// view; every day in a selected range.
  final List<DateTime> days;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            const Spacer(),
            WeightEntryField(days: days, showLastWeightButton: true),
          ],
        ),
      ),
    );
  }
}
