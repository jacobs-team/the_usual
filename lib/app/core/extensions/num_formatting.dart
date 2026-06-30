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
    // Quantities and weights carry at most one decimal place. Fixing to one
    // decimal also clears the floating-point dust toString() would surface
    // (2.2 + 0.1 prints as 2.3000000000000003); whole numbers drop the ".0".
    final oneDecimal = toStringAsFixed(1);
    return oneDecimal.endsWith('.0')
        ? oneDecimal.substring(0, oneDecimal.length - 2)
        : oneDecimal;
  }
}

/// Rounding for calorie and macro values, which are stored as doubles so a
/// small per-unit serving (a 1 oz food) keeps its precision but are always
/// shown as whole numbers.
extension MacroRounding on double {
  /// This value as the whole number shown in the UI. Binary floating-point
  /// dust is cleared first so a value that is mathematically 28.5 — arriving as
  /// 28.4999999 after scaling by a quantity — still rounds to 29 rather than
  /// being pulled down to 28.
  int get rounded => double.parse(toStringAsFixed(4)).round();
}
