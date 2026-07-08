import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template date_navigator}
/// The app bar control that picks which day the Today and Workouts views show:
/// a chevron to step to the previous day, a tappable pill that opens a date
/// picker, and a chevron to step to the next day. The pill reads "Today" on the
/// live view and shows the date otherwise, taking a highlighted fill on any day
/// but today so it's clear at a glance that a past or future day is in view.
/// {@endtemplate}
class DateNavigator extends StatelessWidget {
  /// {@macro date_navigator}
  const DateNavigator({
    required this.selectedRange,
    required this.onRangeChanged,
    super.key,
  });

  /// The day(s) currently shown. Null is the live "today" view; a non-null
  /// range is a specific single day (start == end) or a multi-day span.
  final DateTimeRange? selectedRange;

  /// Called with the new selection when a chevron or the date picker changes
  /// the day. Null means the view should return to the live "today" view.
  final ValueChanged<DateTimeRange?> onRangeChanged;

  @override
  Widget build(BuildContext context) {
    final selectedRange = this.selectedRange;
    final isToday = selectedRange == null;
    final today = clock.now().logicalDay(
      getIt<UserSettingsBloc>().state.dayStartTime,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          key: const Key('date-nav-previous'),
          icon: const Icon(Icons.chevron_left),
          tooltip: 'Previous day',
          visualDensity: VisualDensity.compact,
          onPressed: () =>
              onRangeChanged(selectedDayShifted(selectedRange, -1, today)),
        ),
        FilledButton(
          key: const Key('today-date-pill'),
          style: pillButtonStyle(context, highlighted: !isToday),
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              initialDate: selectedRange?.start ?? today,
            );
            if (picked == null) return;
            final pickedDay = DateUtils.dateOnly(picked);
            onRangeChanged(
              DateUtils.isSameDay(pickedDay, today)
                  ? null
                  : DateTimeRange(start: pickedDay, end: pickedDay),
            );
          },
          child: Text(_label(selectedRange)),
        ),
        IconButton(
          key: const Key('date-nav-next'),
          icon: const Icon(Icons.chevron_right),
          tooltip: 'Next day',
          visualDensity: VisualDensity.compact,
          onPressed: () =>
              onRangeChanged(selectedDayShifted(selectedRange, 1, today)),
        ),
      ],
    );
  }

  /// The pill's label: "Today" for the live view, a single formatted date for
  /// one selected day, or a "start – end" span for a range.
  String _label(DateTimeRange? selectedRange) {
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
    // The date picker only ever selects a single day (start == end), so the
    // span label is unreachable today; kept for when range selection lands.
    return '$startLabel – ${formatDate(selectedRange.end)}';
  }
}
