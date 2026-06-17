/// How an AI-assisted entry turns a meal into log entries.
enum MealEntryMode {
  /// The meal is captured as a single combined item, logged as one entry.
  wholeMeal(
    'One meal',
    summary:
        'Logged as one row with combined nutrition. '
        'Best for one-tap usual meals.',
    detail:
        'Steak and potatoes become a single entry with combined '
        'nutrition. Best for one-tap logging of your usual meals.',
  ),

  /// The meal is broken into its individual foods, each its own entry with its
  /// own count and per-unit nutrition.
  itemized(
    'Itemize',
    summary: 'Each food gets its own row and nutrition.',
    detail:
        'Steak and potatoes become separate entries, steak one row and '
        'potatoes another, each with its own nutrition.',
  );

  const MealEntryMode(
    this.label, {
    required this.summary,
    required this.detail,
  });

  /// Display label for the mode, shown on the entry sheet's toggle.
  final String label;

  /// One-line helper shown under the toggle for the selected mode.
  final String summary;

  /// Fuller explanation of how the mode splits a meal, shown in the
  /// information popup, with a steak-and-potatoes example.
  final String detail;
}
