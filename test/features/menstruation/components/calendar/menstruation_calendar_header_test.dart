import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/components/organisms/calendar/day/calendar_day_tile.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/features/menstruation/components/calendar/menstruation_calendar_header.dart';
import 'package:pilll/features/menstruation/data.dart';
import 'package:pilll/features/record/weekday_badge.dart';
import 'package:pilll/provider/first_weekday.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../../../../helper/mock.mocks.dart';

void main() {
  group("WeekdayBadge", () {
    for (final firstWeekday in [Weekday.Sunday, Weekday.Monday]) {
      // 2020-09-13 は日曜日。月曜日始まりでは今日が右端、日曜日始まりでは左端になる
      testWidgets(
          '週の始まりが $firstWeekday で今日が日曜日 (2020-09-13) の時、曜日の行と今日を含む週の日付が $firstWeekday から並ぶ',
          (WidgetTester tester) async {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now())
            .thenReturn(DateTime.parse("2020-09-13"));

        await tester.pumpWidget(
          ProviderScope(
            overrides: [firstWeekdayProvider.overrideWithValue(firstWeekday)],
            child: MaterialApp(
              home: Material(
                child: MenstruationCalendarHeader(
                  calendarMenstruationBandModels: const [],
                  calendarScheduledMenstruationBandModels: const [],
                  calendarNextPillSheetBandModels: const [],
                  diaries: const [],
                  schedules: const [],
                  pageController: PageController(
                      initialPage:
                          todayCalendarPageIndex(firstWeekday: firstWeekday)),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(
          tester
              .widgetList<WeekdayBadge>(find.byType(WeekdayBadge))
              .map((weekdayBadge) => weekdayBadge.weekday)
              .toList(),
          WeekdayFunctions.weekdaysForFirstWeekday(firstWeekday),
        );
        expect(
          tester
              .widgetList<CalendarDayTile>(find.byType(CalendarDayTile))
              .map((calendarDayTile) => calendarDayTile.weekday)
              .toList(),
          WeekdayFunctions.weekdaysForFirstWeekday(firstWeekday),
        );
        expect(
          tester
              .widgetList<CalendarDayTile>(find.byType(CalendarDayTile))
              .map((calendarDayTile) => calendarDayTile.date)
              .toList(),
          List.generate(
              7,
              (index) => DateTime.parse(firstWeekday == Weekday.Monday
                      ? "2020-09-07"
                      : "2020-09-13")
                  .add(Duration(days: index))),
        );
      });
    }
  });
  group("CalendarDayTile", () {
    for (final firstWeekday in [Weekday.Sunday, Weekday.Monday]) {
      // 週ごとの日付の始まりは「今日の 90 日前を含む週の左端」。2020-09-13 の 90 日前は 2020-06-15 (月曜日)、
      // 2020-09-21 の 90 日前は 2020-06-23 (火曜日) で、日曜日始まりでも月曜日始まりでも 1 週先の週になる
      testWidgets(
          '週の始まりが $firstWeekday で、表示したまま今日が 2020-09-13 から 2020-09-21 に変わって組み直されても、表示中の週の日付は変わらない',
          (WidgetTester tester) async {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now())
            .thenReturn(DateTime.parse("2020-09-13"));
        final pageController = PageController(
            initialPage: todayCalendarPageIndex(firstWeekday: firstWeekday));

        for (final now in [
          DateTime.parse("2020-09-13"),
          DateTime.parse("2020-09-21")
        ]) {
          when(mockTodayRepository.now()).thenReturn(now);
          await tester.pumpWidget(
            ProviderScope(
              overrides: [firstWeekdayProvider.overrideWithValue(firstWeekday)],
              child: MaterialApp(
                home: Material(
                  child: MenstruationCalendarHeader(
                    calendarMenstruationBandModels: const [],
                    calendarScheduledMenstruationBandModels: const [],
                    calendarNextPillSheetBandModels: const [],
                    diaries: const [],
                    schedules: const [],
                    pageController: pageController,
                  ),
                ),
              ),
            ),
          );
          await tester.pump();

          expect(
            tester
                .widgetList<CalendarDayTile>(find.byType(CalendarDayTile))
                .map((calendarDayTile) => calendarDayTile.date)
                .toList(),
            List.generate(
                7,
                (index) => DateTime.parse(firstWeekday == Weekday.Monday
                        ? "2020-09-07"
                        : "2020-09-13")
                    .add(Duration(days: index))),
          );
        }
      });
    }
  });
}
