import 'package:pilll/entity/weekday.dart';
import 'package:pilll/service/day.dart';

DateTime today() {
  return todayRepository.today();
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
}
