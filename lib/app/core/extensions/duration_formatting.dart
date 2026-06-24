/// Formatting helpers for displaying durations in the UI.
extension DurationFormatting on Duration {
  /// A compact clock-style label: "m:ss" under an hour (e.g. 5:30) and
  /// "h:mm:ss" once it reaches an hour (e.g. 1:05:00). Zero reads "0:00".
  String get clockLabel {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    final secondsLabel = seconds.toString().padLeft(2, '0');
    if (hours > 0) {
      final minutesLabel = minutes.toString().padLeft(2, '0');
      return '$hours:$minutesLabel:$secondsLabel';
    }
    return '$minutes:$secondsLabel';
  }
}
