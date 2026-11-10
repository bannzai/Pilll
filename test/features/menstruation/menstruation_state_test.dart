import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/features/menstruation/data.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../../helper/mock.mocks.dart';

void main() {
  group("#menstruationWeekCalendarDataSource", () {
    for (final firstWeekday in [Weekday.Sunday, Weekday.Monday]) {
      group("$firstWeekday 始まり", () {
        // 今日が週の左端・右端・途中のどれでも同じ形になることを確かめる (2020-09-13 は日曜日、14 は月曜日、16 は水曜日、19 は土曜日)
        for (final todayText in ["2020-09-13", "2020-09-14", "2020-09-16", "2020-09-19", "2020-12-31", "2020-02-29"]) {
          test("今日が $todayText の時、全ての週が 7 日で $firstWeekday から始まり、日付が 1 日ずつ続く", () {
            final mockTodayRepository = MockTodayService();
            todayRepository = mockTodayRepository;
            when(mockTodayRepository.now()).thenReturn(DateTime.parse(todayText));

            final dataSource = menstruationWeekCalendarDataSource(firstWeekday: firstWeekday);
            expect(dataSource.every((week) => week.length == Weekday.values.length), isTrue);
            expect(dataSource.every((week) => WeekdayFunctions.weekdayFromDate(week.first) == firstWeekday), isTrue);
            final days = dataSource.expand((week) => week).toList();
            for (var i = 1; i < days.length; i++) {
              expect(daysBetween(days[i - 1], days[i]), 1);
            }
          });
          test("今日が $todayText の時、今日の 90 日前と 90 日後を含む", () {
            final mockTodayRepository = MockTodayService();
            todayRepository = mockTodayRepository;
            when(mockTodayRepository.now()).thenReturn(DateTime.parse(todayText));

            final days = menstruationWeekCalendarDataSource(firstWeekday: firstWeekday).expand((week) => week).toList();
            expect(days.contains(DateTime.parse(todayText).subtract(const Duration(days: 90))), isTrue);
            expect(days.contains(DateTime.parse(todayText).add(const Duration(days: 90))), isTrue);
          });
        }
      });
    }
  });

  group("#todayCalendarPageIndex", () {
    test("日曜日始まりで今日が日曜日 (2020-09-13) の時、今日が左端にある週を指す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-13"));

      expect(
        menstruationWeekCalendarDataSource(firstWeekday: Weekday.Sunday)[todayCalendarPageIndex(firstWeekday: Weekday.Sunday)].first,
        DateTime.parse("2020-09-13"),
      );
    });
    test("月曜日始まりで今日が日曜日 (2020-09-13) の時、今日が右端にある週を指す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-13"));

      expect(
        menstruationWeekCalendarDataSource(firstWeekday: Weekday.Monday)[todayCalendarPageIndex(firstWeekday: Weekday.Monday)],
        List.generate(7, (index) => DateTime.parse("2020-09-07").add(Duration(days: index))),
      );
    });
    test("月曜日始まりで今日が月曜日 (2020-09-14) の時、今日が左端にある週を指す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

      expect(
        menstruationWeekCalendarDataSource(firstWeekday: Weekday.Monday)[todayCalendarPageIndex(firstWeekday: Weekday.Monday)].first,
        DateTime.parse("2020-09-14"),
      );
    });
  });
}
