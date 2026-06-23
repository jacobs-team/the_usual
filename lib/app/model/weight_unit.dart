/// Unit for weight entry.
enum WeightUnit { lb, kg }

/// Converting a weight value between [WeightUnit]s.
extension WeightUnitConversion on WeightUnit {
  /// Converts [value], expressed in [from], into this unit. A no-op when the
  /// units already match.
  double convertFrom(double value, WeightUnit from) {
    if (from == this) return value;
    const poundsPerKilogram = 2.20462;
    return this == WeightUnit.kg
        ? value / poundsPerKilogram
        : value * poundsPerKilogram;
  }
}
