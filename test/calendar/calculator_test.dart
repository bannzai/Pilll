import 'package:Pilll/domain/calendar/calculator.dart';
import 'package:Pilll/domain/calendar/date_range.dart';
import 'package:Pilll/entity/weekday.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Calculator calculator;
  DateTime date;
  setUp(() {
    calculator = Calculator(date);
  });
  group("2020-09-14", () {
    /*
  30   31   1   2   3   4   5  

   6    7   8   9  10  11  12  

  13   14  15  16  17  18  19  

  20   21  22  23  24  25  26  

  27   28  29  30
    */
    date = DateTime.parse("2020-09-14");
    test("#dateTimeForPreviousMonthTile", () {
      expect(calculator.dateTimeForPreviousMonthTile(Weekday.Sunday.index),
          DateTime.parse("2020-08-30"));
      expect(calculator.dateTimeForPreviousMonthTile(Weekday.Monday.index),
          DateTime.parse("2020-08-31"));
    });
    test("#lastDay", () {
      expect(calculator.lastDay(), DateTime.parse("2020-09-30").day);
    });

    test("#weekdayOffset", () {
      expect(calculator.weekdayOffset(), 2);
    });
    test("#previousMonthDayCount", () {
      expect(calculator.previousMonthDayCount(), 2);
    });
    test("#tileCount", () {
      expect(calculator.tileCount(), 2 + 30);
    });
    test("#lineCount", () {
      expect(calculator.lineCount(), 5);
    });
    test("#dateRangeOfLine", () {
      expect(
        calculator.dateRangeOfLine(1),
        DateRange(
          DateTime.parse("2020-08-30"),
          DateTime.parse("2020-09-05"),
        ),
      );
      expect(
        calculator.dateRangeOfLine(2),
        DateRange(
          DateTime.parse("2020-09-06"),
          DateTime.parse("2020-09-12"),
        ),
      );
      expect(
        calculator.dateRangeOfLine(3),
        DateRange(
          DateTime.parse("2020-09-13"),
          DateTime.parse("2020-09-19"),
        ),
      );
      expect(
        calculator.dateRangeOfLine(4),
        DateRange(
          DateTime.parse("2020-09-20"),
          DateTime.parse("2020-09-26"),
        ),
      );
      expect(
        calculator.dateRangeOfLine(5),
        DateRange(
          DateTime.parse("2020-09-27"),
          DateTime.parse("2020-09-30"),
        ),
      );
    });
    test("#notInRangeAtLine", () {
      expect(
        calculator.notInRangeAtLine(1, DateTime.parse("2020-08-31")),
        false,
      );
      expect(
        calculator.notInRangeAtLine(1, DateTime.parse("2020-09-01")),
        false,
      );
      expect(
        calculator.notInRangeAtLine(4, DateTime.parse("2020-09-19")),
        true,
      );
      expect(
        calculator.notInRangeAtLine(3, DateTime.parse("2020-09-19")),
        false,
      );
    });
    test("#offsetForStartPositionAtLine", () {
      expect(
        calculator.offsetForStartPositionAtLine(
          1,
          DateTime.parse("2020-08-31"),
        ),
        1,
      );
      expect(
        calculator.offsetForStartPositionAtLine(
          1,
          DateTime.parse("2020-09-01"),
        ),
        2,
      );
      expect(
        calculator.offsetForStartPositionAtLine(
          4,
          DateTime.parse("2020-09-19"),
        ),
        0,
      );
      expect(
        calculator.offsetForStartPositionAtLine(
          3,
          DateTime.parse("2020-09-19"),
        ),
        6,
      );
    });
  });
}
