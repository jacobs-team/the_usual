/// Quantity sanitizing for logged foods, whose quantity is a [double] so the
/// user can log fractional servings like 0.5 or 1.5.
extension QuantityValue on double {
  /// This value as a valid logged quantity: at least a tenth, and snapped to a
  /// single decimal place so the log only ever stores values like 0.5, 1, or 2.
  /// Rounded rather than truncated so that stepping by tenths, where binary
  /// floating point leaves dust like 1.2999999, still lands on 1.3.
  double get asLoggedQuantity {
    final atLeastATenth = this < 0.1 ? 0.1 : this;
    final tenths = (atLeastATenth * 10).round();
    return tenths / 10;
  }
}
