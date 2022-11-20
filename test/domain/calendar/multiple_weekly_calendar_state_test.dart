import 'package:pilll/components/organisms/calendar/band/calendar_band_function.dart';
import 'package:pilll/utils/datetime/date_range.dart';
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

    group("#isNecessaryLineBreak", () {
      test("2020-08-30 ~ 2020-09-05", () {
        final begin = DateTime.parse("2020-08-30");
        final end = DateTime.parse("2020-09-05");
        final dateRange = DateRange(begin, end);
        expect(
          isNecessaryLineBreak(DateTime.parse("2020-08-31"), dateRange),
          false,
        );
        expect(
          isNecessaryLineBreak(DateTime.parse("2020-09-01"), dateRange),
          false,
        );
        expect(
          isNecessaryLineBreak(DateTime.parse("2020-09-06"), dateRange),
          true,
        );
        expect(
          isNecessaryLineBreak(DateTime.parse("2020-09-19"), dateRange),
          true,
        );
      });
    });
    group("#offsetForStartPositionAtLine", () {
      test("2020-08-30 ~ 2020-09-05", () {
        final begin = DateTime.parse("2020-08-30");
        final end = DateTime.parse("2020-09-05");
        final dateRange = DateRange(begin, end);
        expect(
          offsetForStartPositionAtLine(
            DateTime.parse("2020-08-31"),
            dateRange,
          ),
          1,
        );
        expect(
          offsetForStartPositionAtLine(
            DateTime.parse("2020-09-01"),
            dateRange,
          ),
          2,
        );
      });
    });
  });
}
