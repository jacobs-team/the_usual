import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';
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
                  List<MealLogEntry>
                >(
                  bloc: getIt<DailyLogBloc>(),
                  selector: (state) => state.mealEntries,
                  builder: (context, mealEntries) {
                    final breakdown = mealEntries.breakdownOn(today);
                    return ListView(
                      padding: EdgeInsets.all(AppDesign.spacing.lg),
                      children: [
                        const _WeightTracker(),
                        SizedBox(height: AppDesign.spacing.lg),
                        Text(
                          '${breakdown.calories} cal today',
                          style: textTheme.headlineSmall,
                        ),
                        SizedBox(height: AppDesign.spacing.lg),
                        for (final mealOfTheDay in MealOfTheDay.values)
                          MealLogSection(
                            mealOfTheDay: mealOfTheDay,
                            mealLogEntries:
                                breakdown.entriesByMeal[mealOfTheDay] ??
                                const <MealLogEntry>[],
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
            trailing: TheUsualTextField(
              autoSize: true,
              dense: true,
              textAlign: TextAlign.right,
              initialValue: todayWeight == null
                  ? ''
                  : todayWeight.weight.trimmedDecimal,
              hintText: latestWeight == null
                  ? '—'
                  : latestWeight.weight.trimmedDecimal,
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
        );
      },
    );
  }
}
