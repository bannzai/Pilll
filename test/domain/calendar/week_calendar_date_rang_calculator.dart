import 'package:pilll/components/organisms/calendar/week/utility.dart';
import 'package:pilll/utils/datetime/date_range.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late WeekCalendarDateRangeCalculator calculator;
  late DateTime date;
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    calculator = WeekCalendarDateRangeCalculator(date);
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

    test("#lineCount", () {
      expect(calculator.weeklineCount(), 5);
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
  });
}
