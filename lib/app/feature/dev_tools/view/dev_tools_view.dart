// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template dev_tools_view}
/// A view that provides a user interface for toggling developer settings.
/// {@endtemplate}
class DevToolsView extends StatelessWidget {
  /// {@macro dev_tools_view}
  const DevToolsView({super.key});

  @override
  Widget build(BuildContext context) {
    final devToolsCubit = getIt<DevToolsCubit>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Dev Tools')),
      body: ListView(
        children: [
          const Divider(),
          Center(
            child: Text(
              'Restart Not Required',
              style: theme.textTheme.titleSmall,
            ),
          ),
          const Divider(),
          BlocSelector<DevToolsCubit, DevToolsState, bool>(
            bloc: devToolsCubit,
            selector: (state) => state.isApiDebug,
            builder: (context, isApiDebug) {
              return SwitchListTile(
                onChanged: (value) => devToolsCubit.toggleDebugApi(),
                value: isApiDebug,
                title: Text('Debug API', style: theme.textTheme.bodyLarge),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: Text(
              'Load sample history',
              style: theme.textTheme.bodyLarge,
            ),
            subtitle: const Text(
              'Replaces the log and usuals with seeded days and months',
            ),
            trailing: const Icon(Icons.history),
            onTap: () {
              getIt<DailyLogBloc>().add(
                const DailyLogEvent.sampleDataSeeded(),
              );
              final userSettingsBloc = getIt<UserSettingsBloc>();
              userSettingsBloc.add(
                UserSettingsEvent.settingsCommitted(
                  userSettingsBloc.state.copyWith(
                    usuals: DailyLogBloc.sampleUsuals,
                  ),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: Text(
              'Test Claude connection',
              style: theme.textTheme.bodyLarge,
            ),
            subtitle: const Text(
              'Sends a prompt to Claude and shows the reply',
            ),
            trailing: const Icon(Icons.auto_awesome_outlined),
            onTap: () async {
              final messenger = ScaffoldMessenger.of(context);
              final repository = getIt<MealAiRepository>();
              if (!repository.isConfigured) {
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('No ANTHROPIC_API_KEY set in config.'),
                  ),
                );
                return;
              }
              messenger.showSnackBar(
                const SnackBar(content: Text('Asking Claude…')),
              );
              try {
                final reply = await repository.debugEcho(
                  'Reply with exactly the word: pong',
                );
                log('CLAUDE reply: $reply');
                messenger.showSnackBar(
                  SnackBar(content: Text('Claude: $reply')),
                );
              } catch (error, stackTrace) {
                log('CLAUDE error: $error', stackTrace: stackTrace);
                messenger.showSnackBar(
                  SnackBar(content: Text('Claude error: $error')),
                );
              }
            },
          ),
          const Divider(),
          ListTile(
            title: Text(
              'Test meal extraction',
              style: theme.textTheme.bodyLarge,
            ),
            subtitle: const Text(
              'Asks Claude to estimate nutrition for a sample description',
            ),
            trailing: const Icon(Icons.restaurant_outlined),
            onTap: () async {
              final messenger = ScaffoldMessenger.of(context);
              final repository = getIt<MealAiRepository>();
              if (!repository.isConfigured) {
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('No ANTHROPIC_API_KEY set in config.'),
                  ),
                );
                return;
              }
              messenger.showSnackBar(
                const SnackBar(content: Text('Estimating…')),
              );
              try {
                final suggestions = await repository.suggestFromDescription(
                  'two large eggs and a slice of sourdough toast',
                  mode: MealEntryMode.itemized,
                );
                final summary = suggestions
                    .map(
                      (s) =>
                          '×${s.quantity.trimmedDecimal} ${s.name} '
                          '(${s.nutrition.summary})',
                    )
                    .join('  •  ');
                log('CLAUDE suggestion: $summary');
                messenger.showSnackBar(SnackBar(content: Text(summary)));
              } catch (error, stackTrace) {
                log('CLAUDE extract error: $error', stackTrace: stackTrace);
                messenger.showSnackBar(
                  SnackBar(content: Text('Extract error: $error')),
                );
              }
            },
          ),
          const Divider(),
          ListTile(
            title: Text(
              'Test photo extraction',
              style: theme.textTheme.bodyLarge,
            ),
            subtitle: const Text(
              'Snaps or picks a photo and asks Claude to estimate nutrition',
            ),
            trailing: const Icon(Icons.photo_camera_outlined),
            onTap: () async {
              final messenger = ScaffoldMessenger.of(context);
              final repository = getIt<MealAiRepository>();
              if (!repository.isConfigured) {
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('No ANTHROPIC_API_KEY set in config.'),
                  ),
                );
                return;
              }

              final photo = await pickMealPhoto(context);
              if (photo == null) return;

              messenger.showSnackBar(
                const SnackBar(content: Text('Estimating…')),
              );
              try {
                final suggestions = await repository.suggestFromPhoto(
                  [photo],
                  mode: MealEntryMode.wholeMeal,
                );
                final summary = suggestions
                    .map(
                      (s) =>
                          '×${s.quantity.trimmedDecimal} ${s.name} '
                          '(${s.nutrition.summary})',
                    )
                    .join('  •  ');
                log('CLAUDE photo suggestion: $summary');
                messenger.showSnackBar(SnackBar(content: Text(summary)));
              } catch (error, stackTrace) {
                log('CLAUDE photo error: $error', stackTrace: stackTrace);
                messenger.showSnackBar(
                  SnackBar(content: Text('Photo error: $error')),
                );
              }
            },
          ),
          const Divider(),
          ListTile(
            title: Text(
              'Dump saved storage',
              style: theme.textTheme.bodyLarge,
            ),
            subtitle: const Text(
              'Logs every saved bloc entry to the debug console',
            ),
            trailing: const Icon(Icons.bug_report_outlined),
            onTap: () {
              const storageKeys = [
                'OnboardingBloc',
                'UserSettingsBloc',
                'DailyLogBloc',
                'AuthCubit',
                'DevToolsCubit',
              ];
              for (final storageKey in storageKeys) {
                final value = HydratedBloc.storage.read(storageKey);
                log('HYDRATED[$storageKey] = ${jsonEncode(value)}');
              }
            },
          ),
          const Divider(),
          ListTile(
            title: Text(
              'Restore usuals from log',
              style: theme.textTheme.bodyLarge,
            ),
            subtitle: const Text(
              'Rebuilds the usuals library from logged meals',
            ),
            trailing: const Icon(Icons.restore),
            onTap: () {
              final userSettingsBloc = getIt<UserSettingsBloc>();
              final dailyLogBloc = getIt<DailyLogBloc>();

              final usuals = {
                for (final entry in userSettingsBloc.state.usuals.entries)
                  entry.key: [...entry.value],
              };

              for (final mealLogEntry in dailyLogBloc.state.mealEntries) {
                final usualMealId = mealLogEntry.usualMealId;
                if (usualMealId == null) continue;

                final usualMeals = usuals.putIfAbsent(
                  mealLogEntry.mealOfTheDay,
                  () => <UsualMeal>[],
                );
                final alreadyRestored = usualMeals.any(
                  (usualMeal) => usualMeal.id == usualMealId,
                );
                if (alreadyRestored) continue;

                usualMeals.add(
                  UsualMeal(
                    id: usualMealId,
                    name: mealLogEntry.name,
                    nutrition: mealLogEntry.nutrition,
                  ),
                );
              }

              userSettingsBloc.add(
                UserSettingsEvent.settingsCommitted(
                  userSettingsBloc.state.copyWith(usuals: usuals),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: Text(
              'Reset app state',
              style: theme.textTheme.bodyLarge,
            ),
            subtitle: const Text(
              'Clears all saved data and restarts onboarding',
            ),
            trailing: const Icon(Icons.restart_alt),
            onTap: () async {
              await HydratedBloc.storage.clear();
              getIt<OnboardingBloc>().add(const OnboardingEvent.resetPressed());
              if (context.mounted) context.go(Routes.onboarding);
            },
          ),
        ],
      ),
    );
  }
}
