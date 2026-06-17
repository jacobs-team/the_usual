import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template day_start_section}
/// Settings section for the time a new day begins. Meals and weigh-ins logged
/// before it count toward the previous day, so the Today view doesn't roll
/// over at midnight while the user is still up.
/// {@endtemplate}
class DayStartSection extends StatelessWidget {
  /// {@macro day_start_section}
  const DayStartSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<UserSettingsBloc, UserSettingsState, TimeOfDay>(
      bloc: getIt<UserSettingsBloc>(),
      selector: (state) => state.dayStartTime,
      builder: (context, dayStartTime) {
        return Card(
          margin: EdgeInsets.only(bottom: AppDesign.spacing.sm),
          child: ListTile(
            title: const Text('New day starts at'),
            subtitle: const Text(
              'Anything logged before this counts toward the day before.',
            ),
            trailing: ActionChip(
              label: Text(dayStartTime.format(context)),
              onPressed: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: dayStartTime,
                );
                if (picked != null) {
                  getIt<UserSettingsBloc>().add(
                    UserSettingsEvent.dayStartTimeChanged(picked),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
