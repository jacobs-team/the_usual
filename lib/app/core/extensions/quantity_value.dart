/// Quantity sanitizing for logged foods, whose quantity is a [double] so the
/// user can log fractional servings like 0.5 or 1.5.
extension QuantityValue on double {
  /// This value as a valid logged quantity: at least one, and snapped to a
  /// single decimal place so the log only ever stores values like 1, 1.5, or 2.
  /// Rounded rather than truncated so that stepping by tenths, where binary
  /// floating point leaves dust like 1.2999999, still lands on 1.3.
  double get asLoggedQuantity {
    final atLeastOne = this < 1 ? 1 : this;
    final tenths = (atLeastOne * 10).round();
    return tenths / 10;
  }
}
