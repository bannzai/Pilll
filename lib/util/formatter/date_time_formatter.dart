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

  static String yearAndMonthAndDay(DateTime dateTime) {
    return DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY, "ja_JP").format(dateTime);
  }

  static String jaMonth(DateTime dateTime) {
    return DateFormat(DateFormat.NUM_MONTH, "ja_JP").format(dateTime);
  }

  static String monthAndWeekday(DateTime dateTime) {
    return DateFormat(DateFormat.NUM_MONTH_WEEKDAY_DAY, "ja_JP")
        .format(dateTime);
  }

  static String monthAndDay(DateTime dateTime) {
    return DateFormat(DateFormat.NUM_MONTH_DAY, "ja_JP").format(dateTime);
  }

  static String weekday(DateTime dateTime) {
    return DateFormat(DateFormat.ABBR_WEEKDAY, "ja_JP").format(dateTime);
  }

  static String slashYearAndMonthAndDay(DateTime dateTime) {
    return DateFormat("yyyy/MM/dd", "ja_JP").format(dateTime);
  }

  static String slashYearAndMonth(DateTime dateTime) {
    return DateFormat("yyyy/MM", "ja_JP").format(dateTime);
  }

  static String diaryIdentifier(DateTime dateTime) {
    return DateFormat("yyyyMMdd", "ja_JP").format(dateTime);
  }
}
