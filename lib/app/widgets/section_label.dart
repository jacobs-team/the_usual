import 'package:flutter/material.dart';

/// {@template section_label}
/// Small uppercase-style heading that introduces a form or settings section.
/// {@endtemplate}
class SectionLabel extends StatelessWidget {
  /// {@macro section_label}
  const SectionLabel(this.text, {super.key});

  /// The label text.
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.labelSmall);
  }
}
