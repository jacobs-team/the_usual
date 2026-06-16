/// How an AI-assisted entry turns a meal into log entries.
enum MealEntryMode {
  /// The meal is captured as a single combined item, logged as one entry.
  wholeMeal('Whole meal'),

  /// The meal is broken into its individual foods, each its own entry with its
  /// own count and per-unit nutrition.
  itemized('Individual items');

  const MealEntryMode(this.label);

  /// Display label for the mode, shown on the entry sheet's toggle.
  final String label;
}
