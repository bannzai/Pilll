import 'package:intl/intl.dart';

class DateTimeFormatter {
  static String militaryTime(DateTime dateTime) {
    var formatter = NumberFormat("00");
    return formatter.format(dateTime.hour) +
        ":" +
        formatter.format(dateTime.minute);
  }

  static String yearAndMonth(DateTime dateTime) {
    return DateFormat(DateFormat.YEAR_ABBR_MONTH, "ja_JP").format(dateTime);
  }

  static String monthAndYearAndWeekday(DateTime dateTime) {
    return DateFormat(DateFormat.NUM_MONTH_WEEKDAY_DAY, "ja_JP")
        .format(dateTime);
  }
}
