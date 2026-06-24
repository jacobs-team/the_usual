import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template time_field}
/// An editor for a cardio duration: a minutes field and a seconds field side by
/// side. Reports the combined [Duration] on every change.
/// {@endtemplate}
class TimeField extends StatefulWidget {
  /// {@macro time_field}
  const TimeField({
    required this.initial,
    required this.onChanged,
    super.key,
  });

  /// The duration to seed the fields with.
  final Duration initial;

  /// Called with the combined duration whenever either field changes.
  final ValueChanged<Duration> onChanged;

  @override
  State<TimeField> createState() => _TimeFieldState();
}

class _TimeFieldState extends State<TimeField> {
  late final TextEditingController _minutesController;
  late final TextEditingController _secondsController;

  @override
  void initState() {
    super.initState();
    final minutes = widget.initial.inMinutes;
    final seconds = widget.initial.inSeconds.remainder(60);
    _minutesController = TextEditingController(
      text: minutes == 0 ? '' : minutes.toString(),
    );
    _secondsController = TextEditingController(
      text: seconds == 0 ? '' : seconds.toString(),
    );
  }

  @override
  void dispose() {
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  void _emit() {
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;
    widget.onChanged(Duration(minutes: minutes, seconds: seconds));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: MacroField(
            key: const Key('cardio-minutes'),
            controller: _minutesController,
            unit: 'min',
            maxDigits: 3,
            dense: true,
            textAlign: TextAlign.right,
            onChanged: (_) => _emit(),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDesign.spacing.sm),
          child: const Text(':'),
        ),
        SizedBox(
          width: 110,
          child: MacroField(
            key: const Key('cardio-seconds'),
            controller: _secondsController,
            unit: 'sec',
            maxDigits: 2,
            dense: true,
            textAlign: TextAlign.right,
            onChanged: (_) => _emit(),
          ),
        ),
      ],
    );
  }
}
