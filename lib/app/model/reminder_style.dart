/// How the app checks in with the user about meals.
enum ReminderStyle {
  notifications('Notifications', 'A quick nudge at your meal times.'),
  onAppOpen('When I open the app', 'No pings. We ask when you launch.'),
  none("Don't remind me", 'Log on your own schedule.');

  const ReminderStyle(this.label, this.description);

  /// Display label for the style.
  final String label;

  /// Short description of what the style does.
  final String description;
}
