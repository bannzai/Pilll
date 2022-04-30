import 'package:pilll/components/organisms/calendar/band/calendar_band_function.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/domain/calendar/week_calendar_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  group("2020-09-14", () {
    /*
  30   31   1   2   3   4   5  

   6    7   8   9  10  11  12  

  13   14  15  16  17  18  19  

  20   21  22  23  24  25  26  

  27   28  29  30
    */
    test("#shouldGrayoutTile", () {
      final date = DateTime.parse("2020-09-14");
      final anyDate = date;
      final calendarState = CalendarTabWeeklyCalendarState(
        dateRange: DateRange(anyDate, anyDate.add(const Duration(days: 6))),
        targetDateOfMonth: date,
        diariesForMonth: [],
      );
      expect(calendarState.isGrayoutTile(DateTime.parse("2020-08-30")), true);
      expect(calendarState.isGrayoutTile(DateTime.parse("2020-08-31")), true);
      expect(calendarState.isGrayoutTile(DateTime.parse("2020-09-01")), false);
    });

    group("#isNecessaryLineBreak", () {
      test("2020-08-30 ~ 2020-09-05", () {
        final date = DateTime.parse("2020-09-14");
        final begin = DateTime.parse("2020-08-30");
        final end = DateTime.parse("2020-09-05");
        final calendarState = CalendarTabWeeklyCalendarState(
          dateRange: DateRange(begin, end),
          targetDateOfMonth: date,
          diariesForMonth: [],
        );
        expect(
          isNecessaryLineBreak(
              DateTime.parse("2020-08-31"), calendarState.dateRange),
          false,
        );
        expect(
          isNecessaryLineBreak(
              DateTime.parse("2020-09-01"), calendarState.dateRange),
          false,
        );
        expect(
          isNecessaryLineBreak(
              DateTime.parse("2020-09-06"), calendarState.dateRange),
          true,
        );
        expect(
          isNecessaryLineBreak(
              DateTime.parse("2020-09-19"), calendarState.dateRange),
          true,
        );
      });
    });
    group("#offsetForStartPositionAtLine", () {
      test("2020-08-30 ~ 2020-09-05", () {
        final date = DateTime.parse("2020-09-14");
        final begin = DateTime.parse("2020-08-30");
        final end = DateTime.parse("2020-09-05");
        final calendarState = CalendarTabWeeklyCalendarState(
          dateRange: DateRange(begin, end),
          targetDateOfMonth: date,
          diariesForMonth: [],
        );
        expect(
          offsetForStartPositionAtLine(
            DateTime.parse("2020-08-31"),
            calendarState.dateRange,
          ),
          1,
        );
        expect(
          offsetForStartPositionAtLine(
            DateTime.parse("2020-09-01"),
            calendarState.dateRange,
          ),
          2,
        );
      });
    });
  });
}
