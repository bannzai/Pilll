import 'package:pilll/entity/weekday.dart';
import 'package:pilll/util/datetime/day.dart';

final todayCalendarPageIndex =
    menstruationWeekCalendarDataSource.lastIndexWhere((element) => element.where((element) => isSameDay(element, today())).isNotEmpty);

final List<List<DateTime>> menstruationWeekCalendarDataSource = () {
  final base = today();

  var begin = base.subtract(const Duration(days: 90));
  final beginWeekdayOffset = WeekdayFunctions.weekdayFromDate(begin).index;
  begin = begin.subtract(Duration(days: beginWeekdayOffset));

  var end = base.add(const Duration(days: 90));
  final endWeekdayOffset = Weekday.values.last.index - WeekdayFunctions.weekdayFromDate(end).index;
  end = end.add(Duration(days: endWeekdayOffset));

  var diffDay = daysBetween(begin, end);
  diffDay += Weekday.values.length - diffDay % Weekday.values.length;
  List<DateTime> days = [];
  for (int i = 0; i < diffDay; i++) {
    days.add(begin.add(Duration(days: i)));
  }
  return List.generate(
      ((diffDay) / Weekday.values.length).round(), (i) => days.sublist(i * Weekday.values.length, i * Weekday.values.length + Weekday.values.length));
}();
