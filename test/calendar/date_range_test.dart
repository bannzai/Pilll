import 'package:Pilll/main/calendar/date_range.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  DateRange range;
  DateTime begin;
  DateTime end;
  setUp(() {
    range = DateRange(begin, end);
  });

  test("#isSameday", () {
    expect(
        DateRange.isSameDay(
          DateTime.parse("2020-09-14"),
          DateTime.parse("2020-08-30"),
        ),
        false);
    expect(
        DateRange.isSameDay(
          DateTime.parse("2020-09-14"),
          DateTime.parse("2020-09-14"),
        ),
        true);
  });
  group("begin: 2020-09-13, end: 2020-09-18", () {
    begin = DateTime.parse("2020-09-13");
    end = DateTime.parse("2020-09-18");
    test("#union->days", () {
      expect(
          range
              .union(DateRange(
                  DateTime.parse("2020-09-14"), DateTime.parse("2020-09-15")))
              .days,
          1);
      expect(
          range
              .union(DateRange(
                  DateTime.parse("2020-09-11"), DateTime.parse("2020-09-15")))
              .days,
          2);
      expect(
          range
              .union(DateRange(
                  DateTime.parse("2020-09-14"), DateTime.parse("2020-09-20")))
              .days,
          4);
    });
  });
}
