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
}
