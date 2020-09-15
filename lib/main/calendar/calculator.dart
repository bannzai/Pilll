import 'package:Pilll/model/weekday.dart';

class DateRange {
  final DateTime begin;
  final DateTime end;
  int get days => end.difference(begin).inDays;

  DateRange(this.begin, this.end);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
  bool inRange(DateTime date) =>
      begin.isAfter(date) && date.isBefore(end) ||
      DateRange.isSameDay(date, begin) ||
      DateRange.isSameDay(date, end);
  DateRange union(DateRange range) {
    var l = begin.isAfter(range.begin) ? begin : range.begin;
    var r = end.isBefore(range.end) ? end : range.end;
    return DateRange(l, r);
  }
}

class Calculator {
  final DateTime date;

  Calculator(this.date);

  DateTime dateTimeForFirstDayOfMonth() {
    return DateTime(date.year, date.month, 1);
  }

  DateTime dateTimeForPreviousMonthTile(Weekday weekday) {
    var dateTimeForLastDayOfPreviousMonth = DateTime(date.year, date.month, 0);
    var offset =
        WeekdayFunctions.weekdayFromDate(dateTimeForLastDayOfPreviousMonth)
            .index;
    return DateTime(
        dateTimeForLastDayOfPreviousMonth.year,
        dateTimeForLastDayOfPreviousMonth.month,
        dateTimeForLastDayOfPreviousMonth.day - offset + weekday.index);
  }

  int lastDay() => DateTime(date.year, date.month + 1, 0).day;
  int weekdayOffset() =>
      WeekdayFunctions.weekdayFromDate(dateTimeForFirstDayOfMonth()).index;
  int previousMonthDayCount() => weekdayOffset();
  int tileCount() => previousMonthDayCount() + lastDay();
  int lineCount() => (tileCount() / 7).ceil();

  int numberOfLine(int day) {
    for (int line = 1; line <= lineCount(); line++) {
      if (day <= (line * Weekday.values.length) - weekdayOffset()) {
        return line;
      }
    }
    assert(false, "line not found day is $day");
  }

  DateRange dateRangeOfLine(int line) {
    var beginDay = Weekday.values.length * (line - 1) + previousMonthDayCount();
    var endDay = Weekday.values.length * line - previousMonthDayCount();
    return DateRange(
      DateTime(date.year, date.month, beginDay),
      DateTime(date.year, date.month, endDay),
    );
  }
}
