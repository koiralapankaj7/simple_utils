///
extension SimpleUtilsNumX on num {
  ///  Phone validation
  bool isInRange(num? min, num? max) {
    if (min == null && max == null) return true;
    if (min == null && max != null) return this <= max;
    if (min != null && max == null) return this >= min;
    return this >= min! && this <= max!;
  }
}
