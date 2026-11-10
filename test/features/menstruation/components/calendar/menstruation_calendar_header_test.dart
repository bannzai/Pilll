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
      testWidgets('週の始まりが $firstWeekday で今日が日曜日 (2020-09-13) の時、曜日の行と今日を含む週の日付が $firstWeekday から並ぶ', (WidgetTester tester) async {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-13"));

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
                  pageController: PageController(initialPage: todayCalendarPageIndex(firstWeekday: firstWeekday)),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(
          tester.widgetList<WeekdayBadge>(find.byType(WeekdayBadge)).map((weekdayBadge) => weekdayBadge.weekday).toList(),
          WeekdayFunctions.weekdaysForFirstWeekday(firstWeekday),
        );
        expect(
          tester.widgetList<CalendarDayTile>(find.byType(CalendarDayTile)).map((calendarDayTile) => calendarDayTile.weekday).toList(),
          WeekdayFunctions.weekdaysForFirstWeekday(firstWeekday),
        );
        expect(
          tester.widgetList<CalendarDayTile>(find.byType(CalendarDayTile)).map((calendarDayTile) => calendarDayTile.date).toList(),
          List.generate(7, (index) => DateTime.parse(firstWeekday == Weekday.Monday ? "2020-09-07" : "2020-09-13").add(Duration(days: index))),
        );
      });
    }
  });
}
