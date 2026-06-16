import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template history_view}
/// Logged history browsed a month at a time. A horizontal strip selects the
/// month; swiping the page flips between months. Each month lists its days,
/// and each day expands to show its meals and weigh-in.
/// {@endtemplate}
class HistoryView extends StatefulWidget {
  /// {@macro history_view}
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final DailyLogBloc _dailyLogBloc = getIt<DailyLogBloc>();
  late DateTime _selectedMonth;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    final history = _dailyLogBloc.state.historyByMonth;
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
  /// one is deleted, keeping the page view and the month strip in range.
  void _clampToAvailableMonth(List<HistoryMonth> history) {
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
      appBar: AppBar(centerTitle: true, title: const Text('History')),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<DailyLogBloc, DailyLogState>(
          bloc: _dailyLogBloc,
          builder: (context, state) {
            final history = state.historyByMonth;
            if (history.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(AppDesign.spacing.xl),
                  child: Text(
                    'No history yet. Log a meal or weigh-in and it shows up '
                    'here.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            }

            // The selected month can disappear when its last entry is deleted.
            // Fall back to the nearest remaining page once the frame settles.
            final selectedMonthExists = history.any(
              (monthHistory) =>
                  DateUtils.isSameMonth(monthHistory.month, _selectedMonth),
            );
            if (!selectedMonthExists) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => _clampToAvailableMonth(history),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _MonthSelector(
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
                    itemBuilder: (context, index) {
                      final monthHistory = history[index];
                      final localizations = MaterialLocalizations.of(context);

                      return ListView(
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
                        children: [
                          BlocSelector<
                            UserSettingsBloc,
                            UserSettingsState,
                            (double?, WeightUnit)
                          >(
                            bloc: getIt<UserSettingsBloc>(),
                            selector: (state) => (
                              state.weightGoal,
                              state.weightUnit,
                            ),
                            builder: (context, goal) {
                              final (weightGoal, weightUnit) = goal;
                              return MonthTrendsChart(
                                monthHistory: monthHistory,
                                weightGoal: weightGoal,
                                weightGoalUnit: weightUnit,
                              );
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: AppDesign.spacing.sm,
                            ),
                            child: SectionLabel(
                              localizations
                                  .formatMonthYear(monthHistory.month)
                                  .toUpperCase(),
                            ),
                          ),
                          for (final historyDay in monthHistory.days)
                            _HistoryDayCard(historyDay: historyDay),
                        ],
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

/// The horizontal strip of month chips above the history pages. The selected
/// month is highlighted and scrolled into view as the selection changes.
class _MonthSelector extends StatefulWidget {
  const _MonthSelector({
    required this.history,
    required this.selectedMonth,
    required this.onMonthSelected,
  });

  final List<HistoryMonth> history;
  final DateTime selectedMonth;
  final ValueChanged<int> onMonthSelected;

  @override
  State<_MonthSelector> createState() => _MonthSelectorState();
}

class _MonthSelectorState extends State<_MonthSelector> {
  final GlobalKey<State<StatefulWidget>> _selectedChipKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _revealSelected());
  }

  @override
  void didUpdateWidget(_MonthSelector oldWidget) {
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
                final monthHistory = widget.history[index];
                final monthName = localizations
                    .formatMonthYear(monthHistory.month)
                    .split(' ')
                    .first;
                final abbreviation = monthName
                    .substring(0, monthName.length < 3 ? monthName.length : 3)
                    .toUpperCase();
                final isSelected = DateUtils.isSameMonth(
                  monthHistory.month,
                  widget.selectedMonth,
                );
                final weightEntries = monthHistory.weightEntries;
                final latestWeightEntry = weightEntries.isEmpty
                    ? null
                    : weightEntries.last;
                return Padding(
                  padding: EdgeInsets.only(
                    right: index == widget.history.length - 1
                        ? 0
                        : AppDesign.spacing.sm,
                  ),
                  child: _MonthChip(
                    key: isSelected ? _selectedChipKey : null,
                    label: abbreviation,
                    latestWeightEntry: latestWeightEntry,
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

/// A single month in the selector strip: its abbreviation and the latest
/// weigh-in that month, if any.
class _MonthChip extends StatelessWidget {
  const _MonthChip({
    required this.label,
    required this.latestWeightEntry,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final WeightEntry? latestWeightEntry;
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (latestWeightEntry != null) ...[
                SizedBox(height: AppDesign.spacing.xs),
                Text(
                  latestWeightEntry!.label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: foregroundColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A single day in the history list: a summary that expands to the day's
/// meals grouped by meal time.
class _HistoryDayCard extends StatelessWidget {
  const _HistoryDayCard({required this.historyDay});

  final HistoryDay historyDay;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final weightEntry = historyDay.weightEntry;
    final bodySmall = Theme.of(context).textTheme.bodySmall;

    return Card(
      margin: EdgeInsets.only(bottom: AppDesign.spacing.sm),
      child: ExpansionTile(
        shape: const Border(),
        title: Text(localizations.formatMediumDate(historyDay.day)),
        subtitle: Row(
          children: [
            Flexible(
              child: DefaultTextStyle.merge(
                style: bodySmall,
                child: NutritionSummary(historyDay.nutrition),
              ),
            ),
            if (weightEntry != null)
              Text(' · ${weightEntry.label}', style: bodySmall),
          ],
        ),
        childrenPadding: EdgeInsets.fromLTRB(
          AppDesign.spacing.lg,
          0,
          AppDesign.spacing.lg,
          AppDesign.spacing.md,
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(child: SectionLabel('WEIGHT')),
              WeightEntryField(day: historyDay.day),
            ],
          ),
          SizedBox(height: AppDesign.spacing.sm),
          for (final mealOfTheDay in MealOfTheDay.values)
            if (historyDay.mealEntries.any(
              (mealLogEntry) => mealLogEntry.mealOfTheDay == mealOfTheDay,
            )) ...[
              SectionLabel(mealOfTheDay.label.toUpperCase()),
              for (final mealLogEntry in historyDay.mealEntries)
                if (mealLogEntry.mealOfTheDay == mealOfTheDay)
                  LoggedEntryRow(
                    key: ValueKey(mealLogEntry.id),
                    mealLogEntry: mealLogEntry,
                    expandedByDefault: false,
                  ),
              SizedBox(height: AppDesign.spacing.sm),
            ],
        ],
      ),
    );
  }
}
