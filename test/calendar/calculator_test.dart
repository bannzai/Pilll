import 'package:Pilll/main/calendar/calculator.dart';
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
      ;
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
  });
}
