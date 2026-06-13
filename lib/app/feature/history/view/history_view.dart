import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

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
    final loggedMonths = _dailyLogBloc.state.loggedMonths;
    final initialIndex = loggedMonths.isEmpty ? 0 : loggedMonths.length - 1;
    final now = DateTime.now();
    _selectedMonth = loggedMonths.isEmpty
        ? DateTime(now.year, now.month)
        : loggedMonths[initialIndex];
    _pageController = PageController(initialPage: initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('History')),
      body: SafeArea(
        child: BlocBuilder<DailyLogBloc, DailyLogState>(
          bloc: _dailyLogBloc,
          builder: (context, state) {
            final loggedMonths = state.loggedMonths;
            if (loggedMonths.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'No history yet. Log a meal or weigh-in and it shows up '
                    'here.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _MonthSelector(
                  loggedMonths: loggedMonths,
                  selectedMonth: _selectedMonth,
                  state: state,
                  onMonthSelected: (index) => _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: loggedMonths.length,
                    onPageChanged: (index) =>
                        setState(() => _selectedMonth = loggedMonths[index]),
                    itemBuilder: (context, index) {
                      final month = loggedMonths[index];
                      final localizations = MaterialLocalizations.of(context);

                      return ListView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: SectionLabel(
                              localizations
                                  .formatMonthYear(month)
                                  .toUpperCase(),
                            ),
                          ),
                          for (final day in state.loggedDaysIn(month))
                            _HistoryDayCard(
                              day: day,
                              mealEntries: state.mealEntriesOn(day),
                              calories: state.caloriesOn(day),
                              weightEntry: state.weightOn(day),
                            ),
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
/// month is highlighted and kept in view as the selection changes.
class _MonthSelector extends StatefulWidget {
  const _MonthSelector({
    required this.loggedMonths,
    required this.selectedMonth,
    required this.state,
    required this.onMonthSelected,
  });

  final List<DateTime> loggedMonths;
  final DateTime selectedMonth;
  final DailyLogState state;
  final ValueChanged<int> onMonthSelected;

  @override
  State<_MonthSelector> createState() => _MonthSelectorState();
}

class _MonthSelectorState extends State<_MonthSelector> {
  static const _chipWidth = 76.0;
  static const _chipSpacing = 8.0;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  @override
  void didUpdateWidget(_MonthSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedMonth != widget.selectedMonth) _scrollToSelected();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelected() {
    if (!_scrollController.hasClients) return;
    final selectedIndex = widget.loggedMonths.indexOf(widget.selectedMonth);
    if (selectedIndex < 0) return;

    final viewportWidth = _scrollController.position.viewportDimension;
    const chipExtent = _chipWidth + _chipSpacing;
    final centeredOffset =
        selectedIndex * chipExtent - (viewportWidth - _chipWidth) / 2;
    final maxOffset = _scrollController.position.maxScrollExtent;
    _scrollController.animateTo(
      centeredOffset.clamp(0.0, maxOffset),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    return SizedBox(
      height: 84,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: widget.loggedMonths.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: _chipSpacing),
        itemBuilder: (context, index) {
          final month = widget.loggedMonths[index];
          final monthName = localizations
              .formatMonthYear(month)
              .split(' ')
              .first;
          final abbreviation = monthName
              .substring(0, monthName.length < 3 ? monthName.length : 3)
              .toUpperCase();
          return _MonthChip(
            width: _chipWidth,
            label: abbreviation,
            averageCalories: widget.state.averageDailyCaloriesIn(month),
            isSelected: DateUtils.isSameMonth(month, widget.selectedMonth),
            onTap: () => widget.onMonthSelected(index),
          );
        },
      ),
    );
  }
}

/// A single month in the selector strip: its abbreviation and average daily
/// calories.
class _MonthChip extends StatelessWidget {
  const _MonthChip({
    required this.width,
    required this.label,
    required this.averageCalories,
    required this.isSelected,
    required this.onTap,
  });

  final double width;
  final String label;
  final int averageCalories;
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
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
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
              const SizedBox(height: 4),
              Text(
                '${_compactCalories(averageCalories)} avg cal',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: foregroundColor.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Calories shown compactly in tight spaces: 1,950 reads as "2.0k".
String _compactCalories(int calories) {
  if (calories < 1000) return '$calories';
  return '${(calories / 1000).toStringAsFixed(1)}k';
}

/// A single day in the history list: a summary that expands to the day's
/// meals grouped by meal time.
class _HistoryDayCard extends StatelessWidget {
  const _HistoryDayCard({
    required this.day,
    required this.mealEntries,
    required this.calories,
    required this.weightEntry,
  });

  final DateTime day;
  final List<MealLogEntry> mealEntries;
  final int calories;
  final WeightEntry? weightEntry;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final summary = [
      '${localizations.formatDecimal(calories)} cal',
      if (weightEntry != null) weightEntry!.label,
    ].join(' · ');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        shape: const Border(),
        title: Text(localizations.formatMediumDate(day)),
        subtitle: Text(summary),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final mealOfTheDay in MealOfTheDay.values)
            if (mealEntries.any(
              (mealLogEntry) => mealLogEntry.mealOfTheDay == mealOfTheDay,
            )) ...[
              SectionLabel(mealOfTheDay.label.toUpperCase()),
              for (final mealLogEntry in mealEntries)
                if (mealLogEntry.mealOfTheDay == mealOfTheDay)
                  _HistoryEntryRow(mealLogEntry: mealLogEntry),
              const SizedBox(height: 8),
            ],
        ],
      ),
    );
  }
}

/// A read-only logged meal: name and calories.
class _HistoryEntryRow extends StatelessWidget {
  const _HistoryEntryRow({required this.mealLogEntry});

  final MealLogEntry mealLogEntry;

  @override
  Widget build(BuildContext context) {
    final calories = mealLogEntry.calories;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(mealLogEntry.name)),
          Text(
            calories == null ? '—' : '$calories cal',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
