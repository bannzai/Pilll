import 'package:pilll/entity/weekday.dart';
import 'package:pilll/service/day.dart';
import 'package:timezone/timezone.dart' as tz;

DateTime today() {
  return todayRepository.now().date();
}

DateTime now() {
  return todayRepository.now();
}

DateTime firstDayOfWeekday(DateTime day) {
  return day.subtract(Duration(days: day.weekday == 7 ? 0 : day.weekday));
}

DateTime endDayOfWeekday(DateTime day) {
  return day
      .subtract(Duration(days: day.weekday == 7 ? 0 : day.weekday))
      .add(Duration(days: Weekday.values.length - 1));
}

extension Date on DateTime {
  DateTime date() {
    return DateTime(year, month, day);
  }

  tz.TZDateTime tzDate() {
    return tz.TZDateTime.from(DateTime(year, month, day), tz.local);
  }
}

// Reference: https://stackoverflow.com/questions/52713115/flutter-find-the-number-of-days-between-two-dates/67679455#67679455
int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}
