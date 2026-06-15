import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template weight_entry_field}
/// An inline number field for a single day's weigh-in, prefilled with that
/// day's weight and hinting the last recorded weight. Typing a value sets the
/// weigh-in for [day]; clearing it removes the weigh-in.
/// {@endtemplate}
class WeightEntryField extends StatelessWidget {
  /// {@macro weight_entry_field}
  const WeightEntryField({required this.day, super.key});

  /// The day whose weigh-in this field edits.
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final weightUnit = getIt<UserSettingsBloc>().state.weightUnit;
    return BlocSelector<
      DailyLogBloc,
      DailyLogState,
      (WeightEntry?, WeightEntry?)
    >(
      bloc: getIt<DailyLogBloc>(),
      selector: (state) => (state.weightOn(day), state.latestWeight),
      builder: (context, selected) {
        final (dayWeight, latestWeight) = selected;
        return TheUsualTextField(
          autoSize: true,
          dense: true,
          textAlign: TextAlign.right,
          initialValue: dayWeight == null
              ? ''
              : dayWeight.weight.trimmedDecimal,
          hintText: latestWeight == null
              ? '—'
              : latestWeight.weight.trimmedDecimal,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d{0,4}\.?\d{0,1}')),
          ],
          suffixText: ' ${weightUnit.name}',
          onChanged: (value) => getIt<DailyLogBloc>().add(
            DailyLogEvent.weightOnDayChanged(
              day,
              double.tryParse(value),
              weightUnit,
            ),
          ),
        );
      },
    );
  }
}
