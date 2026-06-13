import 'package:flutter/material.dart';

/// {@template radio_option_card}
/// A tappable card with a title, subtitle, and radio indicator, used for
/// single-choice option lists.
/// {@endtemplate}
class RadioOptionCard extends StatelessWidget {
  /// {@macro radio_option_card}
  const RadioOptionCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    this.note,
    super.key,
  });

  /// The option's name.
  final String title;

  /// Short description of what the option does.
  final String subtitle;

  /// Extra context shown under the subtitle in a muted color.
  final String? note;

  /// Whether this option is the selected one.
  final bool selected;

  /// Called when the card is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(subtitle, style: theme.textTheme.bodySmall),
                  if (note != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      note!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected ? theme.colorScheme.primary : null,
            ),
          ],
        ),
      ),
    );
  }
}
