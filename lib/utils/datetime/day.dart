import 'package:flutter/material.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:timezone/timezone.dart';

class TodayService {
  DateTime now() => DateTime.now();
}

TodayService todayRepository = TodayService();

DateTime today() {
  return todayRepository.now().date();
}

DateTime now() {
  return todayRepository.now();
}

DateTime tomorrow() {
  return today().add(const Duration(days: 1));
}

DateTime yesterday() {
  return today().subtract(const Duration(days: 1));
}

DateTime firstDayOfWeekday(DateTime day) {
  return day.subtract(Duration(days: day.weekday == 7 ? 0 : day.weekday));
}

DateTime endDayOfWeekday(DateTime day) {
  return day.subtract(Duration(days: day.weekday == 7 ? 0 : day.weekday)).addDays(Weekday.values.length - 1);
}

extension Date on DateTime {
  DateTime date() {
    return DateTime(year, month, day);
  }
}

extension TZDate on TZDateTime {
  TZDateTime date() {
    return TZDateTime(location, year, month, day);
  }
}

extension DateTimeBeginEnd on DateTime {
  DateTime beginOfDay() {
    return DateTime(year, month, day, 0, 0, 0);
  }

  DateTime endOfDay() {
    return DateTime(year, month, day, 23, 59, 59);
  }

  DateTimeRange dateTimeRange() {
    return DateTimeRange(start: beginOfDay(), end: endOfDay());
  }
}

extension MonthDateTimeRange on DateTimeRange {
  static DateTimeRange monthRange({required DateTime dateForMonth}) {
    return DateTimeRange(
        start: DateTime(dateForMonth.year, dateForMonth.month, 1), end: DateTime(dateForMonth.year, dateForMonth.month + 1, 0, 23, 59, 59));
  }
}

// Reference: https://stackoverflow.com/questions/52713115/flutter-find-the-number-of-days-between-two-dates/67679455#67679455
// 同じ日だと0を返す
int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}
