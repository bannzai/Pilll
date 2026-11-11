import 'package:pilll/entity/weekday.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/date_compare.dart';
import 'package:pilll/utils/datetime/day.dart';

/// [menstruationWeekCalendarDataSource] のうち今日を含む週の位置。生理タブの週カレンダーが最初に表示するページ。
int todayCalendarPageIndex({required Weekday firstWeekday}) => menstruationWeekCalendarDataSource(firstWeekday: firstWeekday).lastIndexWhere(
      (element) => element.where((element) => isSameDay(element, today())).isNotEmpty,
    );

/// 生理タブの週カレンダーの 1 ページ (1 週間) ごとの日付。今日の前後 90 日を含み、各週は [firstWeekday] から始まる。
List<List<DateTime>> menstruationWeekCalendarDataSource({required Weekday firstWeekday}) {
  final base = today();

  var begin = base.subtract(const Duration(days: 90));
  begin = begin.subtract(Duration(days: weekdayOffset(date: begin, firstWeekday: firstWeekday)));

  var diffDay = daysBetween(begin, endDayOfWeekday(base.add(const Duration(days: 90)), firstWeekday: firstWeekday));
  diffDay += Weekday.values.length - diffDay % Weekday.values.length;
  List<DateTime> days = [];
  for (int i = 0; i < diffDay; i++) {
    days.add(begin.addDays(i));
  }
  return List.generate(
    ((diffDay) / Weekday.values.length).round(),
    (i) => days.sublist(
      i * Weekday.values.length,
      i * Weekday.values.length + Weekday.values.length,
    ),
  );
}
