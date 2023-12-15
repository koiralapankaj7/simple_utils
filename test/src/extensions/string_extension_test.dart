// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_test/flutter_test.dart';
import 'package:simple_utils/src/extensions/string_extension.dart';

void main() {
  group('StringExtension casedFromBase Tests', () {
    test('String starting with lowercase turns to lowercase', () {
      expect('abcd'.casedFromBase, equals('abcd'));
      expect('aBCD'.casedFromBase, equals('abcd'));
    });

    test('String starting with uppercase turns to uppercase', () {
      expect('ABCD'.casedFromBase, equals('ABCD'));
      expect('Abcd'.casedFromBase, equals('ABCD'));
    });

    test('Empty string returns empty', () {
      expect(''.casedFromBase, equals(''));
    });

    test(
        'String with non-alphabetic character at start follows first letter case',
        () {
      expect('123aBCD'.casedFromBase, equals('123aBCD'));
      expect('123ABCD'.casedFromBase, equals('123ABCD'));
    });

    test('Single character string remains unchanged in lowercase', () {
      expect('a'.casedFromBase, equals('a'));
    });

    test('Single character string remains unchanged in uppercase', () {
      expect('A'.casedFromBase, equals('A'));
    });
  });

  group('StringExtension containsSameChar Tests', () {
    test('String with same characters returns true', () {
      expect('aaaa'.containsSameChar, isTrue);
    });

    test('String with same characters different case returns true', () {
      expect('AaAa'.containsSameChar, isTrue);
    });

    test('String with different characters returns false', () {
      expect('abcd'.containsSameChar, isFalse);
    });

    test('Empty string returns false', () {
      expect(''.containsSameChar, isFalse);
    });

    test('Single character string returns true', () {
      expect('a'.containsSameChar, isTrue);
    });

    test('String with same non-alphabetic characters returns true', () {
      expect('1111'.containsSameChar, isTrue);
    });

    test('String with different non-alphabetic characters returns false', () {
      expect('1234'.containsSameChar, isFalse);
    });

    test('String with spaces returns false', () {
      expect('    '.containsSameChar, isFalse);
    });

    test('String with same characters and spaces returns false', () {
      expect('aaa a'.containsSameChar, isFalse);
    });
  });

  group('StringExtension toBool Tests', () {
    test('"true" returns true', () {
      expect('true'.toBool, isTrue);
    });

    test('"True" returns true', () {
      expect('True'.toBool, isTrue);
    });

    test('"1" returns true', () {
      expect('1'.toBool, isTrue);
    });

    test('"false" returns false', () {
      expect('false'.toBool, isFalse);
    });

    test('"False" returns false', () {
      expect('False'.toBool, isFalse);
    });

    test('"0" returns false', () {
      expect('0'.toBool, isFalse);
    });

    test('Empty string returns false', () {
      expect(''.toBool, isFalse);
    });

    test('Arbitrary string returns false', () {
      expect('randomString'.toBool, isFalse);
    });

    test('String with only spaces returns false', () {
      expect('    '.toBool, isFalse);
    });
  });

  group('StringExtension toYear Tests', () {
    final currentYear = DateTime.now().year;
    final currentYearLastTwoDigits = currentYear % 100;
    final nextYearLastTwoDigits = (currentYear + 1) % 100;
    final previousYearLastTwoDigits = (currentYear - 1) % 100;

    test('Valid year in full format', () {
      expect('2023'.toYear, equals(2023));
    });

    test('Valid year in short format', () {
      final shortYear = DateTime.now().year % 100;
      expect('$shortYear'.toYear, equals(DateTime.now().year));
    });

    test('Invalid input returns 0', () {
      expect('invalid'.toYear, equals(0));
    });

    test('Empty string returns 0', () {
      expect(''.toYear, equals(0));
    });

    // Testing a boundary case, e.g., transitioning from 1999 to 2000
    test('Boundary case handling', () {
      expect(
        '99'.toYear,
        isNot(equals(1999)),
      );
    });

    test('Current year in short format', () {
      expect('$currentYearLastTwoDigits'.toYear, equals(currentYear));
    });

    test('Next year in short format', () {
      expect('$nextYearLastTwoDigits'.toYear, equals(currentYear + 1));
    });

    test('Previous year in short format', () {
      expect('$previousYearLastTwoDigits'.toYear, equals(currentYear - 1));
    });

    test('Far future year in short format', () {
      expect('50'.toYear, greaterThan(currentYear));
    });

    test('Far past year in short format', () {
      expect('10'.toYear, lessThan(currentYear));
    });

    test('Single digit year', () {
      expect('5'.toYear, greaterThan(currentYear));
    });

    test('Long string that is not a year', () {
      expect('1234567890'.toYear, equals(0));
    });

    test('Year far in the past', () {
      expect('1900'.toYear, equals(1900));
    });

    test('Year far in the future', () {
      expect('3000'.toYear, equals(3000));
    });

    test('Year with leading zeros', () {
      expect('0099'.toYear, equals(99));
    });
  });

  group('StringExtension chunks() Tests', () {
    test('Chunks string into equal parts', () {
      final result = '12345678901234567890'.chunks(4);
      expect(result, equals(['1234', '5678', '9012', '3456', '7890']));
    });

    test('Handles string length not divisible by chunk size', () {
      final result = '123456789'.chunks(2);
      expect(result, equals(['12', '34', '56', '78', '9']));
    });

    test('Handles string shorter than chunk size', () {
      final result = '123'.chunks(4);
      expect(result, equals(['123']));
    });

    test('Handles empty string', () {
      final result = ''.chunks(2);
      expect(result, isEmpty);
    });

    test('Return same value for zero or negative chunk size', () {
      expect('1234'.chunks(0), ['1234']);
    });
  });
}
