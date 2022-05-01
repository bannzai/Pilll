import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/domain/menstruation/menstruation_state.codegen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group("#calendarDataSource", () {
    test("limit testing for every time", () {
      // NOTE: If calculating calendarDataSource is missing. Maybe throw exception about range error.
      expect(menstruationWeekCalendarDataSource.length / 7, greaterThan(0));
    });
  });
}
