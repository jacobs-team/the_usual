/// When in the day the weigh-in happens.
enum WeightTimeOfDay {
  morning('Morning · recommended'),
  evening('Evening'),
  night('Night');

  const WeightTimeOfDay(this.label);

  /// Display label for the time of day.
  final String label;
}
