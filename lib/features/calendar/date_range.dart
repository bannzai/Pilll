import 'package:pilll/utils/datetime/day.dart';

class DateRange {
  final DateTime _begin;
  final DateTime _end;
  DateTime get begin => _begin.date();
  DateTime get end => _end.date();
  int get days => daysBetween(begin, end);

  DateRange(this._begin, this._end);

  static bool isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
  bool inRange(DateTime date) => (date.isAfter(begin) && date.isBefore(end)) || DateRange.isSameDay(date, begin) || DateRange.isSameDay(date, end);
  DateRange union(DateRange range) {
    var l = begin.isAfter(range.begin) ? begin : range.begin;
    var r = end.isBefore(range.end) ? end : range.end;
    return DateRange(l, r);
  }

  List<DateTime> list() => List.generate(days + 1, (index) => _begin.add(Duration(days: index)));

  T map<T extends dynamic>(T Function(DateRange) converter) {
    return converter(this);
  }

  @override
  bool operator ==(other) {
    if (other is! DateRange) {
      return false;
    }
    return begin == other.begin && end == other.end;
  }

  @override
  String toString() {
    return "begin: $_begin, end: $_end";
  }

  @override
  // ignore: unnecessary_overrides
  int get hashCode => super.hashCode;
}
