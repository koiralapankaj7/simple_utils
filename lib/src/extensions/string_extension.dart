import 'dart:math' as math;

import '../simple_reg_exp.dart';

/// Useful extension functions for [String]
extension SimpleUtilsStringX on String {
  /// Returns the capitalized string
  String get capitalize =>
      '${this[0].toUpperCase()}${substring(1).toLowerCase()}';

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

  /// Returns true if all characters in the string are in lower case.
  bool get isLower => toLowerCase() == this;

  /// Returns true if all characters in the string are in upper case.
  bool get isUpper => toUpperCase() == this;

  /// Returns true if the string consists of the same character,
  /// case insensitive.
  bool get containsSameChar {
    if (trim().isEmpty) return false;
    final char = this[0].toLowerCase();
    for (var i = 1; i < length; i++) {
      if (this[i].toLowerCase() != char) return false;
    }
    return true;
  }

  /// Converts string to lowerCase/upperCase based on the first character (base).
  /// If the first character is not a letter, the original string is returned.
  String get casedFromBase {
    if (isEmpty) return '';

    // String has initial numeric value return as it is
    if (RegExp(r'^\d').hasMatch(this)) {
      return this;
    }

    return this[0].isLower ? toLowerCase() : toUpperCase();
  }

  ///
  bool get toBool {
    switch (toLowerCase()) {
      case 'true' || '1':
        return true;
      case 'false' || '0':
        return false;
      default:
        return false;
    }
  }

  /// Convert string into the year
  int get toYear {
    final input = int.tryParse(this) ?? 0;
    if (input == 0) return 0;
    final currentYear = DateTime.now().year;
    final delta = '$currentYear'.length - length;
    if (delta.isNegative) return 0;
    if (delta > 0) {
      final factor = math.pow(10, length);
      final prefix = (currentYear ~/ factor) * factor;
      return (prefix + input).toInt();
    }
    return input;
  }

  /// Splits the string into chunks of the given [size].
  ///
  /// The last chunk may be shorter if the string length is not a multiple of
  /// chunk [size]
  List<String> chunks(int size) {
    if (size <= 0) return [this];
    final chunks = <String>[];
    for (var i = 0; i < length; i += size) {
      final end = math.min(i + size, length);
      chunks.add(substring(i, end));
    }
    return chunks;
  }

  /// Convert camelCase string into title `Camel Case`
  String get camelCaseToTitle {
    if (isEmpty) return this;

    final buffer = StringBuffer(this[0].toUpperCase());

    for (var i = 1; i < length; i++) {
      final char = this[i];
      if (char.toUpperCase() == char) {
        buffer.write(' ');
      }
      buffer.write(char);
    }

    return buffer.toString();
  }
}
