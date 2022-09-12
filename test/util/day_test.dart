import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/util/datetime/day.dart';

void main() {
  group("#daysBetween", () {
    test("difference in 1 hour", () {
      DateTime date1 = DateTime.parse("2020-01-09 23:00:00.299871");
      DateTime date2 = DateTime.parse("2020-01-10 00:00:00.299871");

      expect(daysBetween(date1, date2), 1);
    });
    test("difference in 1 minute", () {
      DateTime date1 = DateTime.parse("2020-01-09 23:59:59.299871");
      DateTime date2 = DateTime.parse("2020-01-10 00:00:00.299871");

      expect(daysBetween(date1, date2), 1);
    });
    test("it is same day", () {
      DateTime date1 = DateTime.parse("2020-01-10 00:00:00.299871");
      DateTime date2 = DateTime.parse("2020-01-10 23:59:59.299871");

      expect(daysBetween(date1, date2), 0);
    });
  });

  group("#dateRange", () {
    test("difference in 1 hour", () {
      DateTime date = DateTime.parse("2020-01-09 23:00:00.299871");

      expect(date.dateTimeRange().start, DateTime(2020, 1, 9));
      expect(date.dateTimeRange().end, DateTime(2020, 1, 9, 23, 59, 59));
    });
  });
}
