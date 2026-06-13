import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/l10n/l10n.dart';

/// {@template today_view}
/// The Today view: tracks the day's weight and logs the day's meals from the
/// user's usuals, with a running calorie total.
/// {@endtemplate}
class TodayView extends StatelessWidget {
  /// {@macro today_view}
  const TodayView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final today = DateTime.now();
    final currentMeal = MealOfTheDay.fromTime(TimeOfDay.fromDateTime(today));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Today'),
        actions: [
          IconButton(
            onPressed: () => context.push(Routes.history),
            tooltip: context.l10n.historyTooltip,
            icon: const Icon(Icons.history),
          ),
          IconButton(
            onPressed: () => context.go(Routes.settings),
            tooltip: context.l10n.settingsTooltip,
            icon: const Icon(Icons.settings_outlined),
          ),
          if (kDebugMode)
            IconButton(
              onPressed: () => context.push(Routes.devTools),
              tooltip: context.l10n.devToolsTooltip,
              icon: const Icon(Icons.code),
            ),
        ],
      ),
      body: SafeArea(
        child:
            BlocSelector<
              UserSettingsBloc,
              UserSettingsState,
              Map<MealOfTheDay, List<UsualMeal>>
            >(
              bloc: getIt<UserSettingsBloc>(),
              selector: (state) => state.usuals,
              builder: (context, usualMeals) {
                return BlocSelector<
                  DailyLogBloc,
                  DailyLogState,
                  (int, List<MealLogEntry>)
                >(
                  bloc: getIt<DailyLogBloc>(),
                  selector: (state) => (
                    state.caloriesOn(today),
                    state.mealEntries,
                  ),
                  builder: (context, selected) {
                    final (caloriesToday, mealEntries) = selected;
                    final todaysEntries = mealEntries
                        .where(
                          (mealLogEntry) =>
                              DateUtils.isSameDay(mealLogEntry.loggedAt, today),
                        )
                        .toList();
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        const _WeightTracker(),
                        const SizedBox(height: 16),
                        Text(
                          '$caloriesToday cal today',
                          style: textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        for (final mealOfTheDay in MealOfTheDay.values)
                          MealLogSection(
                            mealOfTheDay: mealOfTheDay,
                            mealLogEntries: todaysEntries
                                .where(
                                  (mealLogEntry) =>
                                      mealLogEntry.mealOfTheDay == mealOfTheDay,
                                )
                                .toList(),
                            usualMeals:
                                usualMeals[mealOfTheDay] ?? <UsualMeal>[],
                            isCurrent: mealOfTheDay == currentMeal,
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
}

/// Today's weight tracker: an inline field for today's weigh-in, prefilled
/// with the last recorded weight as a hint.
class _WeightTracker extends StatelessWidget {
  const _WeightTracker();

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final weightUnit = getIt<UserSettingsBloc>().state.weightUnit;
    return BlocSelector<
      DailyLogBloc,
      DailyLogState,
      (WeightEntry?, WeightEntry?)
    >(
      bloc: getIt<DailyLogBloc>(),
      selector: (state) => (state.weightOn(today), state.latestWeight),
      builder: (context, selected) {
        final (todayWeight, latestWeight) = selected;
        return Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            title: const Text('Weight'),
            trailing: SizedBox(
              child: TheUsualTextField(
                autoSize: true,
                dense: true,
                textAlign: TextAlign.right,
                initialValue: todayWeight == null
                    ? ''
                    : _formatWeight(todayWeight.weight),
                hintText: latestWeight == null
                    ? '—'
                    : _formatWeight(latestWeight.weight),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d{0,4}\.?\d{0,1}'),
                  ),
                ],
                suffixText: ' ${weightUnit.name}',
                onChanged: (value) => getIt<DailyLogBloc>().add(
                  DailyLogEvent.todayWeightChanged(
                    double.tryParse(value),
                    weightUnit,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Replaced by the inline weight field in _WeightTracker. Kept for reference.
// /// Dialog that captures a weight value. Pops with the entered weight, or
// /// null when cancelled.
// class _LogWeightDialog extends StatefulWidget {
//   const _LogWeightDialog({
//     required this.initialWeight,
//     required this.weightUnit,
//   });
//
//   final double? initialWeight;
//   final WeightUnit weightUnit;
//
//   @override
//   State<_LogWeightDialog> createState() => _LogWeightDialogState();
// }
//
// class _LogWeightDialogState extends State<_LogWeightDialog> {
//   late final TextEditingController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     final weight = widget.initialWeight;
//     _controller = TextEditingController(
//       text: weight == null ? '' : _formatWeight(weight),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _submit() {
//     Navigator.of(context).pop(double.tryParse(_controller.text));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Log weight'),
//       content: TheUsualTextField(
//         controller: _controller,
//         autofocus: true,
//         keyboardType: const TextInputType.numberWithOptions(decimal: true),
//         suffixText: ' ${widget.weightUnit.name}',
//         onSubmitted: (_) => _submit(),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: const Text('Cancel'),
//         ),
//         FilledButton(onPressed: _submit, child: const Text('Save')),
//       ],
//     );
//   }
// }

String _formatWeight(double weight) {
  return weight == weight.roundToDouble()
      ? weight.toInt().toString()
      : weight.toString();
}
