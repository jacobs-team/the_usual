import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template weight_entry_field}
/// An inline number field for a range of days' weigh-in, prefilled with that
/// day's weight and hinting the last recorded weight. Typing a value sets the
/// weigh-in for [days]; clearing it removes the weigh-in.
///
/// When [showLastWeightButton] is set and the first day has no weigh-in yet, a
/// "Use last" button inside the field fills in the most recent recorded weight.
/// {@endtemplate}
class WeightEntryField extends StatefulWidget {
  /// {@macro weight_entry_field}
  const WeightEntryField({
    required this.days,
    this.showLastWeightButton = false,
    super.key,
  });

  /// The days whose weigh-in this field edits. The field displays and prefills
  /// the weigh-in for the first day; entering or clearing a value writes it to
  /// every day, so a multi-day range logs the same weight across all of them.
  final List<DateTime> days;

  /// Whether to offer an in-field button that fills the last recorded weight
  /// when the first day has no weigh-in.
  final bool showLastWeightButton;

  @override
  State<WeightEntryField> createState() => _WeightEntryFieldState();
}

class _WeightEntryFieldState extends State<WeightEntryField> {
  final DailyLogBloc _dailyLogBloc = getIt<DailyLogBloc>();
  final TimeOfDay _dayStart = getIt<UserSettingsBloc>().state.dayStartTime;
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  DateTime get _displayDay => widget.days.first;

  @override
  void initState() {
    super.initState();
    final dayWeight = _dailyLogBloc.state.weightOn(_displayDay, _dayStart);
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
          previous.weightOn(_displayDay, _dayStart) !=
          current.weightOn(_displayDay, _dayStart),
      listener: (context, state) {
        final dayWeight = state.weightOn(_displayDay, _dayStart);
        final text = dayWeight == null ? '' : dayWeight.weight.trimmedDecimal;
        // While the field is focused, skip the sync only when the state is
        // echoing back what the user is typing, so a trailing decimal isn't
        // wiped mid-entry. A value that differs from the field's content is an
        // external change (e.g. the "Use last" button) and must still apply.
        final isEchoOfTyping =
            _focusNode.hasFocus &&
            double.tryParse(_controller.text) == dayWeight?.weight;
        if (isEchoOfTyping) return;
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
                (state.weightOn(_displayDay, _dayStart), state.latestWeight),
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
                suffixIconConstraints: const BoxConstraints(),
                suffixIcon: canUseLast
                    ? TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDesign.spacing.sm,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: () {
                          for (final day in widget.days) {
                            _dailyLogBloc.add(
                              DailyLogEvent.weightOnDayChanged(
                                day,
                                latestWeight.weight,
                                latestWeight.weightUnit,
                                _dayStart,
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Use last (${latestWeight.weight.trimmedDecimal})',
                        ),
                      )
                    : null,
                onChanged: (value) {
                  for (final day in widget.days) {
                    _dailyLogBloc.add(
                      DailyLogEvent.weightOnDayChanged(
                        day,
                        double.tryParse(value),
                        weightUnit,
                        _dayStart,
                      ),
                    );
                  }
                },
              );
            },
          ),
    );
  }
}
