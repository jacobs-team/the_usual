/// How often the user weighs in.
enum WeightCheckinFrequency {
  daily('Daily'),
  everyTwoDays('Every 2 days'),
  weekly('Weekly'),
  off('Off');

  const WeightCheckinFrequency(this.label);

  /// Display label for the frequency.
  final String label;
}
