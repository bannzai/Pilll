import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/service/day.dart';

DateTime today() {
  return todayRepository.now().date();
}

DateTime now() {
  return todayRepository.now();
}

DateTime tomorrow() {
  return today().add(const Duration(days: 1));
}

DateTime firstDayOfWeekday(DateTime day) {
  return day.subtract(Duration(days: day.weekday == 7 ? 0 : day.weekday));
}

DateTime endDayOfWeekday(DateTime day) {
  return day.subtract(Duration(days: day.weekday == 7 ? 0 : day.weekday)).add(Duration(days: Weekday.values.length - 1));
}

extension Date on DateTime {
  DateTime date() {
    return DateTime(year, month, day);
  }
}

extension DateTimeBeginEnd on DateTime {
  DateTime begin() {
    return DateTime(year, month, day, 0, 0, 0);
  }

  DateTime end() {
    return DateTime(year, month, day, 23, 59, 59);
  }

  DateRange dateRange() {
    return DateRange(begin(), end());
  }
}

// Reference: https://stackoverflow.com/questions/52713115/flutter-find-the-number-of-days-between-two-dates/67679455#67679455
int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}
