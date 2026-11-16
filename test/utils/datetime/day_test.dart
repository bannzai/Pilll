import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/utils/datetime/day.dart';

void main() {
  group("#daysBetween", () {
    test("difference in 1 hour", () {
      DateTime date1 = DateTime.parse("2020-01-09 23:00:00.299871");
      DateTime date2 = DateTime.parse("2020-01-10 00:00:00.299871");

      expect(daysBetween(date1, date2), 1);
    });
    test("difference in 1 minute", () {
      DateTime date1 = DateTime.parse("2020-01-09 23:59:59.299871");
      DateTime date2 = DateTime.parse("2020-01-10 00:00:00.299871");

      expect(daysBetween(date1, date2), 1);
    });
    test("it is same day", () {
      DateTime date1 = DateTime.parse("2020-01-10 00:00:00.299871");
      DateTime date2 = DateTime.parse("2020-01-10 23:59:59.299871");

      expect(daysBetween(date1, date2), 0);
    });
  });

  group("#weekdayOffset", () {
    test("日曜日始まりで日曜日は左端の 0", () {
      expect(weekdayOffset(date: DateTime.parse("2020-09-13"), firstWeekday: Weekday.Sunday), 0);
    });
    test("日曜日始まりで土曜日は右端の 6", () {
      expect(weekdayOffset(date: DateTime.parse("2020-09-19"), firstWeekday: Weekday.Sunday), 6);
    });
    test("月曜日始まりで月曜日は左端の 0", () {
      expect(weekdayOffset(date: DateTime.parse("2020-09-14"), firstWeekday: Weekday.Monday), 0);
    });
    test("月曜日始まりで日曜日は右端の 6", () {
      expect(weekdayOffset(date: DateTime.parse("2020-09-13"), firstWeekday: Weekday.Monday), 6);
    });
    test("月曜日始まりで土曜日は 5", () {
      expect(weekdayOffset(date: DateTime.parse("2020-09-19"), firstWeekday: Weekday.Monday), 5);
    });
  });

  group("#endDayOfWeekday", () {
    group("日曜日始まり", () {
      test("日曜日はその週の土曜日", () {
        expect(endDayOfWeekday(DateTime.parse("2020-09-13"), firstWeekday: Weekday.Sunday), DateTime.parse("2020-09-19"));
      });
      test("土曜日はその日", () {
        expect(endDayOfWeekday(DateTime.parse("2020-09-19"), firstWeekday: Weekday.Sunday), DateTime.parse("2020-09-19"));
      });
      test("年をまたぐ週 (2020-12-31 は木曜日) は翌年の土曜日", () {
        expect(endDayOfWeekday(DateTime.parse("2020-12-31"), firstWeekday: Weekday.Sunday), DateTime.parse("2021-01-02"));
      });
    });
    group("月曜日始まり", () {
      test("日曜日はその日", () {
        expect(endDayOfWeekday(DateTime.parse("2020-09-13"), firstWeekday: Weekday.Monday), DateTime.parse("2020-09-13"));
      });
      test("月曜日は 6 日後の日曜日", () {
        expect(endDayOfWeekday(DateTime.parse("2020-09-14"), firstWeekday: Weekday.Monday), DateTime.parse("2020-09-20"));
      });
      test("土曜日は翌日の日曜日", () {
        expect(endDayOfWeekday(DateTime.parse("2020-09-19"), firstWeekday: Weekday.Monday), DateTime.parse("2020-09-20"));
      });
      test("月をまたぐ週 (2020-09-30 は水曜日) は翌月の日曜日", () {
        expect(endDayOfWeekday(DateTime.parse("2020-09-30"), firstWeekday: Weekday.Monday), DateTime.parse("2020-10-04"));
      });
      test("年をまたぐ週 (2020-12-31 は木曜日) は翌年の日曜日", () {
        expect(endDayOfWeekday(DateTime.parse("2020-12-31"), firstWeekday: Weekday.Monday), DateTime.parse("2021-01-03"));
      });
    });
  });

  group("#dateRange", () {
    test("difference in 1 hour", () {
      DateTime date = DateTime.parse("2020-01-09 23:00:00.299871");

      expect(date.dateTimeRange().start, DateTime(2020, 1, 9));
      expect(date.dateTimeRange().end, DateTime(2020, 1, 9, 23, 59, 59));
    });
  });

  group("#MonthDateTimeRange.monthRange", () {
    test("", () {
      DateTime date = DateTime.parse("2020-01-09 23:00:00.299871");
      final range = MonthDateTimeRange.monthRange(dateForMonth: date);

      expect(range.start, DateTime(2020, 1, 1));
      expect(range.end, DateTime(2020, 1, 31, 23, 59, 59));
    });
  });
}
