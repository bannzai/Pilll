import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/util/datetime/day.dart';

void main() {
  group("#daysBetween", () {
    DateTime date1 = DateTime.parse("2020-01-09 23:00:00.299871");
    DateTime date2 = DateTime.parse("2020-01-10 00:00:00.299871");

    expect(daysBetween(date1, date2), 1);
  });
}
