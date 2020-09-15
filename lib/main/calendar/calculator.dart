import 'package:Pilll/main/calendar/date_range.dart';
import 'package:Pilll/model/weekday.dart';

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
