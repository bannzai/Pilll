import 'package:Pilll/main/calendar/date_range.dart';
import 'package:Pilll/model/weekday.dart';

class Calculator {
  final DateTime date;

  Calculator(this.date);

  DateTime dateTimeForFirstDayOfMonth() {
    return DateTime(date.year, date.month, 1);
  }

  DateTime dateTimeForPreviousMonthTile(int offset) {
    var dateTimeForLastDayOfPreviousMonth = DateTime(date.year, date.month, 0);
    var lastDayForPreviousMonthWeekdayIndex =
        WeekdayFunctions.weekdayFromDate(dateTimeForLastDayOfPreviousMonth)
            .index;
    return DateTime(
        dateTimeForLastDayOfPreviousMonth.year,
        dateTimeForLastDayOfPreviousMonth.month,
        dateTimeForLastDayOfPreviousMonth.day -
            lastDayForPreviousMonthWeekdayIndex +
            offset);
  }

  int lastDay() => DateTime(date.year, date.month + 1, 0).day;
  int weekdayOffset() =>
      WeekdayFunctions.weekdayFromDate(dateTimeForFirstDayOfMonth()).index;
  int previousMonthDayCount() => weekdayOffset();
  int tileCount() => previousMonthDayCount() + lastDay();
  int lineCount() => (tileCount() / 7).ceil();

  DateRange dateRangeOfLine(int line) {
    if (line == 1) {
      return DateRange(
        DateTime(date.year, date.month, 1),
        DateTime(date.year, date.month,
            Weekday.values.length - previousMonthDayCount()),
      );
    }
    if (line == lineCount()) {
      return DateRange(
        DateTime(date.year, date.month,
            Weekday.values.length * (line - 1) + 1 - previousMonthDayCount()),
        DateTime(date.year, date.month, lastDay()),
      );
    }
    var beginDay =
        Weekday.values.length * (line - 1) - previousMonthDayCount() + 1;
    var endDay = Weekday.values.length * line - previousMonthDayCount();
    return DateRange(
      DateTime(date.year, date.month, beginDay),
      DateTime(date.year, date.month, endDay),
    );
  }

  bool notInRangeAtLine(int line, DateTime date) {
    var range = dateRangeOfLine(line);
    return !range.inRange(date);
  }

  int offsetForStartPositionAtLine(int line, DateTime begin) {
    if (line == 1) return previousMonthDayCount();
    var range = dateRangeOfLine(line);
    var isLineBreaked = notInRangeAtLine(line, begin);
    return isLineBreaked ? 0 : begin.difference(range.begin).inDays;
  }
}
