import 'package:pilll/domain/calendar/calendar_state.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late MonthlyCalendarState calendarState;
  late DateTime date;
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    calendarState = MonthlyCalendarState(date);
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
      expect(calendarState.dateTimeForPreviousMonthTile(Weekday.Sunday.index),
          DateTime.parse("2020-08-30"));
      expect(calendarState.dateTimeForPreviousMonthTile(Weekday.Monday.index),
          DateTime.parse("2020-08-31"));
    });

    test("#lineCount", () {
      expect(calendarState.lineCount(), 5);
    });
    test("#dateRangeOfLine", () {
      expect(
        calendarState.dateRangeOfLine(1),
        DateRange(
          DateTime.parse("2020-08-30"),
          DateTime.parse("2020-09-05"),
        ),
      );
      expect(
        calendarState.dateRangeOfLine(2),
        DateRange(
          DateTime.parse("2020-09-06"),
          DateTime.parse("2020-09-12"),
        ),
      );
      expect(
        calendarState.dateRangeOfLine(3),
        DateRange(
          DateTime.parse("2020-09-13"),
          DateTime.parse("2020-09-19"),
        ),
      );
      expect(
        calendarState.dateRangeOfLine(4),
        DateRange(
          DateTime.parse("2020-09-20"),
          DateTime.parse("2020-09-26"),
        ),
      );
      expect(
        calendarState.dateRangeOfLine(5),
        DateRange(
          DateTime.parse("2020-09-27"),
          DateTime.parse("2020-09-30"),
        ),
      );
    });
    test("#notInRangeAtLine", () {
      expect(
        calendarState.notInRangeAtLine(1, DateTime.parse("2020-08-31")),
        false,
      );
      expect(
        calendarState.notInRangeAtLine(1, DateTime.parse("2020-09-01")),
        false,
      );
      expect(
        calendarState.notInRangeAtLine(4, DateTime.parse("2020-09-19")),
        true,
      );
      expect(
        calendarState.notInRangeAtLine(3, DateTime.parse("2020-09-19")),
        false,
      );
    });
    test("#offsetForStartPositionAtLine", () {
      expect(
        calendarState.offsetForStartPositionAtLine(
          1,
          DateTime.parse("2020-08-31"),
        ),
        1,
      );
      expect(
        calendarState.offsetForStartPositionAtLine(
          1,
          DateTime.parse("2020-09-01"),
        ),
        2,
      );
      expect(
        calendarState.offsetForStartPositionAtLine(
          4,
          DateTime.parse("2020-09-19"),
        ),
        0,
      );
      expect(
        calendarState.offsetForStartPositionAtLine(
          3,
          DateTime.parse("2020-09-19"),
        ),
        6,
      );
    });
  });
}
