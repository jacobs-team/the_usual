import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template weight_entry_field}
/// An inline number field for a single day's weigh-in, prefilled with that
/// day's weight and hinting the last recorded weight. Typing a value sets the
/// weigh-in for [day]; clearing it removes the weigh-in.
///
/// When [showLastWeightButton] is set and [day] has no weigh-in yet, a "Use
/// last" button inside the field fills in the most recent recorded weight.
/// {@endtemplate}
class WeightEntryField extends StatefulWidget {
  /// {@macro weight_entry_field}
  const WeightEntryField({
    required this.day,
    this.showLastWeightButton = false,
    super.key,
  });

  /// The day whose weigh-in this field edits.
  final DateTime day;

  /// Whether to offer an in-field button that fills the last recorded weight
  /// when [day] has no weigh-in.
  final bool showLastWeightButton;

  @override
  State<WeightEntryField> createState() => _WeightEntryFieldState();
}

class _WeightEntryFieldState extends State<WeightEntryField> {
  final DailyLogBloc _dailyLogBloc = getIt<DailyLogBloc>();
  final TimeOfDay _dayStart = getIt<UserSettingsBloc>().state.dayStartTime;
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final dayWeight = _dailyLogBloc.state.weightOn(widget.day, _dayStart);
    _controller = TextEditingController(
      text: dayWeight == null ? '' : dayWeight.weight.trimmedDecimal,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weightUnit = getIt<UserSettingsBloc>().state.weightUnit;
    return BlocListener<DailyLogBloc, DailyLogState>(
      bloc: _dailyLogBloc,
      listenWhen: (previous, current) =>
          previous.weightOn(widget.day, _dayStart) !=
          current.weightOn(widget.day, _dayStart),
      listener: (context, state) {
        // Sync the field to externally-set weight (e.g. the "Use last"
        // button), but never while the user is typing, so a trailing decimal
        // isn't wiped mid-entry.
        if (_focusNode.hasFocus) return;
        final dayWeight = state.weightOn(widget.day, _dayStart);
        final text = dayWeight == null ? '' : dayWeight.weight.trimmedDecimal;
        if (_controller.text != text) _controller.text = text;
      },
      child:
          BlocSelector<
            DailyLogBloc,
            DailyLogState,
            (WeightEntry?, WeightEntry?)
          >(
            bloc: _dailyLogBloc,
            selector: (state) =>
                (state.weightOn(widget.day, _dayStart), state.latestWeight),
            builder: (context, selected) {
              final (dayWeight, latestWeight) = selected;
              final canUseLast =
                  widget.showLastWeightButton &&
                  dayWeight == null &&
                  latestWeight != null;
              return TheUsualTextField(
                controller: _controller,
                focusNode: _focusNode,
                autoSize: true,
                dense: true,
                textAlign: TextAlign.right,
                hintText: '—',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d{0,4}\.?\d{0,1}'),
                  ),
                ],
                suffixText: ' ${weightUnit.name}',
                suffixIcon: canUseLast
                    ? TextButton(
                        onPressed: () => _dailyLogBloc.add(
                          DailyLogEvent.weightOnDayChanged(
                            widget.day,
                            latestWeight.weight,
                            latestWeight.weightUnit,
                            _dayStart,
                          ),
                        ),
                        child: Text(
                          'Use last (${latestWeight.weight.trimmedDecimal})',
                        ),
                      )
                    : null,
                onChanged: (value) => _dailyLogBloc.add(
                  DailyLogEvent.weightOnDayChanged(
                    widget.day,
                    double.tryParse(value),
                    weightUnit,
                    _dayStart,
                  ),
                ),
              );
            },
          ),
    );
  }
}
