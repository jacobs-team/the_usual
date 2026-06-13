import 'package:flutter/material.dart';

/// {@template settings_nav_row}
/// A settings list row: a titled card with a subtitle and a trailing chevron
/// that runs [onTap] when pressed.
/// {@endtemplate}
class SettingsNavRow extends StatelessWidget {
  /// {@macro settings_nav_row}
  const SettingsNavRow({
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  /// The row's title.
  final String title;

  /// The supporting text shown beneath the title.
  final String subtitle;

  /// Called when the row is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
