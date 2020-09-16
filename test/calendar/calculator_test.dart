import 'package:Pilll/main/calendar/calculator.dart';
import 'package:Pilll/main/calendar/date_range.dart';
import 'package:Pilll/model/weekday.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Calculator calculator;
  DateTime date;
  setUp(() {
    calculator = Calculator(date);
  });
  group("2020-09-14", () {
    date = DateTime.parse("2020-09-14");
    test("#dateTimeForPreviousMonthTile", () {
      expect(calculator.dateTimeForPreviousMonthTile(Weekday.Sunday),
          DateTime.parse("2020-08-30"));
      expect(calculator.dateTimeForPreviousMonthTile(Weekday.Monday),
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
    test("#numberOfLine", () {
      expect(calculator.numberOfLine(1), 1);
      expect(calculator.numberOfLine(5), 1);
      expect(calculator.numberOfLine(6), 2);
      expect(calculator.numberOfLine(12), 2);
      expect(calculator.numberOfLine(13), 3);
      expect(calculator.numberOfLine(19), 3);
      expect(calculator.numberOfLine(20), 4);
      expect(calculator.numberOfLine(26), 4);
      expect(calculator.numberOfLine(27), 5);
      expect(calculator.numberOfLine(30), 5);
    });
    test("#dateRangeOfLine -> begin", () {
      expect(
        calculator.dateRangeOfLine(1),
        DateRange(
          DateTime.parse("2020-09-01"),
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
  });
}
