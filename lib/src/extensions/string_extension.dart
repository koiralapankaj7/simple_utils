/// Useful extension functions for [String]
extension StringX on String {
  /// Returns the capitalized string
  String get capitalize =>
      '${this[0].toUpperCase()}${substring(1).toLowerCase()}';

  ///
  String get validatedURL => startsWith('http') ? this : 'https://$this';

  /// Convert string date to local date time
  DateTime? get toLocalDateTime {
    final date = DateTime.tryParse(this);
    if (date == null) return null;
    return date.add(date.timeZoneOffset);
  }
}
