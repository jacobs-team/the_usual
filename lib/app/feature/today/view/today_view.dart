import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
class TodayView extends StatefulWidget {
  /// {@macro today_view}
  const TodayView({super.key});

  @override
  State<TodayView> createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> with WidgetsBindingObserver {
  Timer? _refreshTimer;

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
    final textTheme = Theme.of(context).textTheme;
    final now = clock.now();
    final today = DateUtils.dateOnly(now);
    final currentMeal = getIt<UserSettingsBloc>().state.currentMeal(now);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Today'),
        actions: [
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
        // The floating nav bar overlays the bottom of the content, so let the
        // list flow behind it rather than reserving space for it here.
        bottom: false,
        child:
            BlocSelector<
              UserSettingsBloc,
              UserSettingsState,
              (Map<MealOfTheDay, List<UsualMeal>>, bool)
            >(
              bloc: getIt<UserSettingsBloc>(),
              selector: (state) => (
                state.usuals,
                state.expandNutritionByDefault,
              ),
              builder: (context, selected) {
                final (usualMeals, expandNutritionByDefault) = selected;
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
                      // The bottom inset carries the floating nav bar's height
                      // (injected by NavigationWrapper) so the last meal can
                      // scroll clear of it.
                      padding:
                          EdgeInsets.all(AppDesign.spacing.lg) +
                          EdgeInsets.only(
                            bottom: MediaQuery.paddingOf(context).bottom,
                          ),
                      children: [
                        const SectionLabel('WEIGHT'),
                        SizedBox(height: AppDesign.spacing.sm),
                        _WeightTracker(day: today),
                        SizedBox(height: AppDesign.spacing.xl),
                        const SectionLabel('MEALS'),
                        SizedBox(height: AppDesign.spacing.sm),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                breakdown.nutrition.summary,
                                style: textTheme.headlineSmall,
                              ),
                            ),
                            _NutritionExpansionToggle(
                              expanded: expandNutritionByDefault,
                            ),
                          ],
                        ),
                        SizedBox(height: AppDesign.spacing.md),
                        for (final mealOfTheDay in MealOfTheDay.values)
                          MealLogSection(
                            mealOfTheDay: mealOfTheDay,
                            mealLogEntries:
                                breakdown.entriesByMeal[mealOfTheDay] ??
                                const <MealLogEntry>[],
                            usualMeals:
                                usualMeals[mealOfTheDay] ?? <UsualMeal>[],
                            isCurrent: mealOfTheDay == currentMeal,
                            nutritionExpandedByDefault:
                                expandNutritionByDefault,
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

/// Toggles whether every meal's nutrition starts expanded, swapping between
/// the expand and collapse icons with a short animation as the setting flips.
class _NutritionExpansionToggle extends StatelessWidget {
  const _NutritionExpansionToggle({required this.expanded});

  /// Whether nutrition currently starts expanded.
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return IconButton(
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
    );
  }
}

/// Today's weight tracker: an inline field for [day]'s weigh-in, prefilled
/// with the last recorded weight as a hint.
class _WeightTracker extends StatelessWidget {
  const _WeightTracker({required this.day});

  /// The day whose weigh-in this field records.
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        title: const Text('Weight'),
        trailing: WeightEntryField(day: day),
      ),
    );
  }
}
