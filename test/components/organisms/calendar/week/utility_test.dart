import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/components/organisms/calendar/week/utility.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/utils/datetime/date_range.dart';

void main() {
  group("#weeklineCount", () {
    test("日曜日始まりで、火曜日から始まる 30 日の月 (2020-09) は 5 行", () {
      expect(WeekCalendarDateRangeCalculator(DateTime.parse("2020-09-14"), firstWeekday: Weekday.Sunday).weeklineCount(), 5);
    });
    test("月曜日始まりで、火曜日から始まる 30 日の月 (2020-09) は 5 行", () {
      expect(WeekCalendarDateRangeCalculator(DateTime.parse("2020-09-14"), firstWeekday: Weekday.Monday).weeklineCount(), 5);
    });
    test("日曜日始まりで、日曜日から始まる 30 日の月 (2020-11) は前月の日が無く 5 行", () {
      expect(WeekCalendarDateRangeCalculator(DateTime.parse("2020-11-14"), firstWeekday: Weekday.Sunday).weeklineCount(), 5);
    });
    test("月曜日始まりで、日曜日から始まる 30 日の月 (2020-11) は前月の日が 6 日入り 6 行", () {
      expect(WeekCalendarDateRangeCalculator(DateTime.parse("2020-11-14"), firstWeekday: Weekday.Monday).weeklineCount(), 6);
    });
    test("日曜日始まりで、月曜日から始まる 28 日の月 (2021-02) は 5 行", () {
      expect(WeekCalendarDateRangeCalculator(DateTime.parse("2021-02-14"), firstWeekday: Weekday.Sunday).weeklineCount(), 5);
    });
    test("月曜日始まりで、月曜日から始まる 28 日の月 (2021-02) は前月の日が無く 4 行", () {
      expect(WeekCalendarDateRangeCalculator(DateTime.parse("2021-02-14"), firstWeekday: Weekday.Monday).weeklineCount(), 4);
    });
  });

  group("#dateRangeOfLine", () {
    test("日曜日始まりの 2020-09 は各行が日曜日から土曜日で、最後の行は月末で終わる", () {
      /*
  30   31   1   2   3   4   5

   6    7   8   9  10  11  12

  13   14  15  16  17  18  19

  20   21  22  23  24  25  26

  27   28  29  30
    */
      final calculator = WeekCalendarDateRangeCalculator(DateTime.parse("2020-09-14"), firstWeekday: Weekday.Sunday);
      expect(calculator.dateRangeOfLine(1), DateRange(DateTime.parse("2020-08-30"), DateTime.parse("2020-09-05")));
      expect(calculator.dateRangeOfLine(2), DateRange(DateTime.parse("2020-09-06"), DateTime.parse("2020-09-12")));
      expect(calculator.dateRangeOfLine(3), DateRange(DateTime.parse("2020-09-13"), DateTime.parse("2020-09-19")));
      expect(calculator.dateRangeOfLine(4), DateRange(DateTime.parse("2020-09-20"), DateTime.parse("2020-09-26")));
      expect(calculator.dateRangeOfLine(5), DateRange(DateTime.parse("2020-09-27"), DateTime.parse("2020-09-30")));
    });
    test("月曜日始まりの 2020-09 は各行が月曜日から日曜日で、最後の行は月末で終わる", () {
      /*
  31    1   2   3   4   5   6

   7    8   9  10  11  12  13

  14   15  16  17  18  19  20

  21   22  23  24  25  26  27

  28   29  30
    */
      final calculator = WeekCalendarDateRangeCalculator(DateTime.parse("2020-09-14"), firstWeekday: Weekday.Monday);
      expect(calculator.dateRangeOfLine(1), DateRange(DateTime.parse("2020-08-31"), DateTime.parse("2020-09-06")));
      expect(calculator.dateRangeOfLine(2), DateRange(DateTime.parse("2020-09-07"), DateTime.parse("2020-09-13")));
      expect(calculator.dateRangeOfLine(3), DateRange(DateTime.parse("2020-09-14"), DateTime.parse("2020-09-20")));
      expect(calculator.dateRangeOfLine(4), DateRange(DateTime.parse("2020-09-21"), DateTime.parse("2020-09-27")));
      expect(calculator.dateRangeOfLine(5), DateRange(DateTime.parse("2020-09-28"), DateTime.parse("2020-09-30")));
    });
    test("月曜日始まりで日曜日から始まる月 (2020-11) は 1 行目の右端だけが当月で、6 行目は月末の 1 日だけになる", () {
      final calculator = WeekCalendarDateRangeCalculator(DateTime.parse("2020-11-14"), firstWeekday: Weekday.Monday);
      expect(calculator.dateRangeOfLine(1), DateRange(DateTime.parse("2020-10-26"), DateTime.parse("2020-11-01")));
      expect(calculator.dateRangeOfLine(2), DateRange(DateTime.parse("2020-11-02"), DateTime.parse("2020-11-08")));
      expect(calculator.dateRangeOfLine(5), DateRange(DateTime.parse("2020-11-23"), DateTime.parse("2020-11-29")));
      expect(calculator.dateRangeOfLine(6), DateRange(DateTime.parse("2020-11-30"), DateTime.parse("2020-11-30")));
    });
    test("日曜日始まりで日曜日から始まる月 (2020-11) は 1 行目が 1 日から始まる", () {
      final calculator = WeekCalendarDateRangeCalculator(DateTime.parse("2020-11-14"), firstWeekday: Weekday.Sunday);
      expect(calculator.dateRangeOfLine(1), DateRange(DateTime.parse("2020-11-01"), DateTime.parse("2020-11-07")));
      expect(calculator.dateRangeOfLine(5), DateRange(DateTime.parse("2020-11-29"), DateTime.parse("2020-11-30")));
    });
    test("月曜日始まりで月曜日から始まる 28 日の月 (2021-02) は 1 行目が 1 日から始まり、最後の行が 7 日ぶん埋まる", () {
      final calculator = WeekCalendarDateRangeCalculator(DateTime.parse("2021-02-14"), firstWeekday: Weekday.Monday);
      expect(calculator.dateRangeOfLine(1), DateRange(DateTime.parse("2021-02-01"), DateTime.parse("2021-02-07")));
      expect(calculator.dateRangeOfLine(4), DateRange(DateTime.parse("2021-02-22"), DateTime.parse("2021-02-28")));
    });
    test("日曜日始まりで月曜日から始まる 28 日の月 (2021-02) は 1 行目が前月の 1 日から始まり、5 行目は月末の 1 日だけになる", () {
      final calculator = WeekCalendarDateRangeCalculator(DateTime.parse("2021-02-14"), firstWeekday: Weekday.Sunday);
      expect(calculator.dateRangeOfLine(1), DateRange(DateTime.parse("2021-01-31"), DateTime.parse("2021-02-06")));
      expect(calculator.dateRangeOfLine(5), DateRange(DateTime.parse("2021-02-28"), DateTime.parse("2021-02-28")));
    });
    test("年をまたぐ月 (2021-01。1 日は金曜日) の 1 行目は前年の日から始まる", () {
      expect(
        WeekCalendarDateRangeCalculator(DateTime.parse("2021-01-14"), firstWeekday: Weekday.Sunday).dateRangeOfLine(1),
        DateRange(DateTime.parse("2020-12-27"), DateTime.parse("2021-01-02")),
      );
      expect(
        WeekCalendarDateRangeCalculator(DateTime.parse("2021-01-14"), firstWeekday: Weekday.Monday).dateRangeOfLine(1),
        DateRange(DateTime.parse("2020-12-28"), DateTime.parse("2021-01-03")),
      );
    });
    test("うるう年の 2 月 (2020-02。1 日は土曜日) の最後の行は 29 日で終わる", () {
      final sundayCalculator = WeekCalendarDateRangeCalculator(DateTime.parse("2020-02-14"), firstWeekday: Weekday.Sunday);
      expect(sundayCalculator.dateRangeOfLine(1), DateRange(DateTime.parse("2020-01-26"), DateTime.parse("2020-02-01")));
      expect(sundayCalculator.weeklineCount(), 5);
      expect(sundayCalculator.dateRangeOfLine(5), DateRange(DateTime.parse("2020-02-23"), DateTime.parse("2020-02-29")));

      final mondayCalculator = WeekCalendarDateRangeCalculator(DateTime.parse("2020-02-14"), firstWeekday: Weekday.Monday);
      expect(mondayCalculator.dateRangeOfLine(1), DateRange(DateTime.parse("2020-01-27"), DateTime.parse("2020-02-02")));
      expect(mondayCalculator.weeklineCount(), 5);
      expect(mondayCalculator.dateRangeOfLine(5), DateRange(DateTime.parse("2020-02-24"), DateTime.parse("2020-02-29")));
    });
  });
}
