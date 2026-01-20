import 'dart:io';

import 'package:intl/intl.dart';

class DateTimeFormatter {
  static String militaryTime(DateTime dateTime) {
    var formatter = NumberFormat('00');
    return '${formatter.format(dateTime.hour)}:${formatter.format(dateTime.minute)}';
  }

  static String yearAndMonth(DateTime dateTime) {
    return DateFormat(
      DateFormat.YEAR_ABBR_MONTH,
      Platform.localeName,
    ).format(dateTime);
  }

  static String yearAndMonthAndDay(DateTime dateTime) {
    return DateFormat(
      DateFormat.YEAR_ABBR_MONTH_DAY,
      Platform.localeName,
    ).format(dateTime);
  }

  static String jaMonth(DateTime dateTime) {
    return DateFormat(
      DateFormat.NUM_MONTH,
      Platform.localeName,
    ).format(dateTime);
  }

  static String monthAndWeekday(DateTime dateTime) {
    return DateFormat(
      DateFormat.NUM_MONTH_WEEKDAY_DAY,
      Platform.localeName,
    ).format(dateTime);
  }

  // 9/1, 10/1, 11/10,
  static String monthAndDay(DateTime dateTime) {
    return DateFormat(DateFormat.NUM_MONTH_DAY, 'ja_JP').format(dateTime);
  }

  // 2022/01/08
  static String slashYearAndMonthAndDay(DateTime dateTime) {
    return DateFormat('yyyy/MM/dd', Platform.localeName).format(dateTime);
  }

  // 2022/01/08 12:20
  static String slashYearAndMonthAndDayAndTime(DateTime dateTime) {
    final date = slashYearAndMonthAndDay(dateTime);
    final time = hourAndMinute(dateTime);
    return '$date $time';
  }

  // 2022/01
  static String slashYearAndMonth(DateTime dateTime) {
    return DateFormat('yyyy/MM', Platform.localeName).format(dateTime);
  }

  static String slashMonthAndDay(DateTime dateTime) {
    return DateFormat('MM/dd', Platform.localeName).format(dateTime);
  }

  static String diaryIdentifier(DateTime dateTime) {
    return DateFormat('yyyyMMdd', Platform.localeName).format(dateTime);
  }

  // 12:20
  static String hourAndMinute(DateTime dateTime) {
    final format = NumberFormat('00');
    return '${format.format(dateTime.hour)}:${format.format(dateTime.minute)}';
  }

  // 12:20:30
  static String clock(int hour, minute, second) {
    final format = NumberFormat('00');
    return '${format.format(hour)}:${format.format(minute)}:${format.format(second)}';
  }

  // 月火水木金土日
  static String shortWeekday(DateTime dateTime) {
    return DateFormat.E(Platform.localeName).format(dateTime);
  }

  // [日月火水木金土]
  static List<String> shortWeekdays() {
    return DateFormat.E(Platform.localeName).dateSymbols.SHORTWEEKDAYS;
  }
}
