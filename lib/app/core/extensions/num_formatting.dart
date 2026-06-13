/// Formatting helpers for displaying numbers in the UI.
extension NumberFormatting on num {
  /// This count written compactly for tight spaces: 1,950 reads as "2.0k",
  /// while values under 1000 stay as-is.
  String get compact {
    if (this < 1000) return toInt().toString();
    return '${(this / 1000).toStringAsFixed(1)}k';
  }

  /// This number with a trailing ".0" dropped: 165.0 reads as "165", while
  /// 165.5 stays "165.5".
  String get trimmedDecimal {
    return this == roundToDouble() ? toInt().toString() : toString();
  }
}
