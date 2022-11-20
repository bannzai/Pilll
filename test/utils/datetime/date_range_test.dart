import 'package:pilll/utils/datetime/date_range.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late DateRange range;
  late DateTime begin;
  late DateTime end;
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    range = DateRange(begin, end);
  });

  test("#isSameday", () {
    expect(
        DateRange.isSameDay(
          DateTime.parse("2020-09-14"),
          DateTime.parse("2020-08-30"),
        ),
        false);
    expect(
        DateRange.isSameDay(
          DateTime.parse("2020-09-14"),
          DateTime.parse("2020-09-14"),
        ),
        true);
  });
  group("begin: 2020-09-13, end: 2020-09-18", () {
    begin = DateTime.parse("2020-09-13");
    end = DateTime.parse("2020-09-18");
    test("#union->days", () {
      expect(
          range
              .union(DateRange(
                  DateTime.parse("2020-09-14"), DateTime.parse("2020-09-15")))
              .days,
          1);
      expect(
          range
              .union(DateRange(
                  DateTime.parse("2020-09-11"), DateTime.parse("2020-09-15")))
              .days,
          2);
      expect(
          range
              .union(DateRange(
                  DateTime.parse("2020-09-14"), DateTime.parse("2020-09-20")))
              .days,
          4);
    });
    test("#inRange", () {
      expect(range.inRange(DateTime.parse("2020-09-14")), true);
      expect(range.inRange(DateTime.parse("2020-09-13")), true);
      expect(range.inRange(DateTime.parse("2020-09-18")), true);
      expect(range.inRange(DateTime.parse("2020-09-12")), false);
      expect(range.inRange(DateTime.parse("2020-09-20")), false);
    });
  });

  group("#days", () {
    final begin = DateTime(2020, 10, 1, 23, 59);
    final end = DateTime(2020, 10, 2, 0, 1);
    final range = DateRange(begin, end);
    test("test boundary test", () {
      expect(range.days, equals(1));
    });
  });
}
