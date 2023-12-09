import '../simple_reg_exp.dart';

/// Useful extension functions for [String]
extension SimpleUtilsStringX on String {
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

  /// Password validation
  bool get isValidPassword {
    if (!SimpleRegExp.lowercase.hasMatch(this)) return false;
    if (!SimpleRegExp.uppercase.hasMatch(this)) return false;
    if (!SimpleRegExp.number.hasMatch(this)) return false;
    if (!SimpleRegExp.specialCharacters.hasMatch(this)) return false;
    return true;
  }

  /// Email validation
  bool get isValidEmail => SimpleRegExp.email.hasMatch(this);

  /// Phone validation
  bool get isValidPhone => SimpleRegExp.phone.hasMatch(this);

  ///
  bool? get boolOrNull {
    switch (toLowerCase()) {
      case 'true':
        return true;
      case 'false':
        return false;
      default:
        return false;
    }
  }
}
