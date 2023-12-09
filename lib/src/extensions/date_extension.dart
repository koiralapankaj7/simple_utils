import 'package:intl/intl.dart';

///
extension SimpleUtilsDateTimeX on DateTime {
  /// Formatted string
  String formattedString({
    bool timeOnly = false,
    String separator = 'AT',
  }) {
    final now = DateTime.now();
    final difference = now.difference(this);
    final diffDays = difference.inDays;

    final sameDay = day == now.day;
    final sameWeek = diffDays < now.weekday;
    final sameYear = diffDays <= 365;

    if (sameDay) {
      return DateFormat('HH:mm').format(this);
    } else if (sameWeek) {
      return DateFormat(timeOnly ? 'EEE' : 'EEE $separator HH:mm').format(this);
    } else if (sameYear) {
      return DateFormat(timeOnly ? 'MMM d' : 'MMM d $separator HH:mm')
          .format(this);
    }
    return DateFormat(timeOnly ? 'MMM d, yyyy' : 'MMM d, yyyy $separator HH:mm')
        .format(this);
  }
}
