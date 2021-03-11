import 'package:pilll/entity/weekday.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group("#weekdayFromDate", () {
    test("with 2020-10-15 is Thursday", () {
      expect(
        WeekdayFunctions.weekdayFromDate(DateTime.parse("2020-10-15")),
        Weekday.Thursday,
      );
    });
  });
  group("#weekdaysForFirstWeekday", () {
    test("pass Thursday", () {
      expect(
        WeekdayFunctions.weekdaysForFirstWeekday(Weekday.Thursday),
        [
          Weekday.Thursday,
          Weekday.Friday,
          Weekday.Saturday,
          Weekday.Sunday,
          Weekday.Monday,
          Weekday.Tuesday,
          Weekday.Wednesday,
        ],
      );
    });
  });
}
