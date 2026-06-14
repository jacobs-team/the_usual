import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      body: Column(
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
              'Replaces the log with seeded days and months',
            ),
            trailing: const Icon(Icons.history),
            onTap: () => getIt<DailyLogBloc>().add(
              const DailyLogEvent.sampleDataSeeded(),
            ),
          ),
        ],
      ),
    );
  }
}
