/// How the app checks in with the user about meals.
enum ReminderStyle {
  notifications(
    'Notifications',
    'A quick nudge at your meal times.',
    permissionNote: "We'll ask for permission next.",
  ),
  onAppOpen('When I open the app', 'No pings. We ask when you launch.'),
  none("Don't remind me", 'Log on your own schedule.');

  const ReminderStyle(this.label, this.description, {this.permissionNote});

  /// Display label for the style.
  final String label;

  /// Short description of what the style does.
  final String description;

  /// Extra note shown when this style is chosen, or null when there's nothing
  /// more to surface. Choosing notifications prompts for OS permission.
  final String? permissionNote;
}
