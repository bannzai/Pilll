import 'package:Pilll/util/datetime/day.dart';

class DateRange {
  DateTime begin;
  DateTime end;
  int get days => end.difference(begin).inDays;

  DateRange(DateTime begin, DateTime end) {
    this.begin = begin.date();
    this.end = end.date();
  }

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
  bool inRange(DateTime date) =>
      date.isAfter(begin) && date.isBefore(end) ||
      DateRange.isSameDay(date, begin) ||
      DateRange.isSameDay(date, end);
  DateRange union(DateRange range) {
    var l = begin.isAfter(range.begin) ? begin : range.begin;
    var r = end.isBefore(range.end) ? end : range.end;
    return DateRange(l, r);
  }

  T map<T extends dynamic>(T Function(DateRange) converter) {
    return converter(this);
  }

  @override
  bool operator ==(other) {
    if (other == null) {
      return false;
    }
    if (other is! DateRange) {
      return false;
    }
    return this.begin == other.begin && this.end == other.end;
  }

  @override
  int get hashCode => super.hashCode;
}
