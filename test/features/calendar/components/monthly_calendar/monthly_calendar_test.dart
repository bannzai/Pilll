import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_next_pill_sheet_band.dart';
import 'package:pilll/features/calendar/components/month_calendar/month_calendar.dart';
import 'package:pilll/components/organisms/calendar/week/week_calendar.dart';
import 'package:pilll/utils/datetime/date_range.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/provider/diary.dart';
import 'package:pilll/provider/schedule.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    WidgetsBinding.instance.renderView.configuration = TestViewConfiguration.fromView(
      view: WidgetsBinding.instance.platformDispatcher.views.single,
      size: const Size(375.0, 667.0),
    );
  });
  group("Appearance Next Sheet Label", () {
    testWidgets('when showing 新しいシート開始 ▶︎', (WidgetTester tester) async {
      /*
  30   31   1   2   3   4   5  

   6    7   8   9  10  11  12  

  13   14  15  16  17  18  19  
           ==============
  20   21  22  23  24  25  26  

  27   28  29  30  
    */
      var now = DateTime(2020, 09, 14);
      var model = CalendarNextPillSheetBandModel(DateTime(2020, 09, 15), DateTime(2020, 09, 18));
      final diaries = [Diary.fromDate(now)];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diariesForMonthProvider.overrideWith((ref, arg) => Stream.value(diaries)),
            schedulesForMonthProvider.overrideWith((ref, arg) => Stream.value([])),
          ],
          child: MaterialApp(
            home: MonthCalendar(
              dateForMonth: DateTime(2020, 09, 14),
              weekCalendarBuilder: (context, diaries, schedules, weekDateRange) {
                return CalendarWeekLine(
                  dateRange: weekDateRange,
                  calendarMenstruationBandModels: const [],
                  calendarScheduledMenstruationBandModels: const [],
                  calendarNextPillSheetBandModels: [model],
                  horizontalPadding: 0,
                  day: (p0, p1, p2) => Container(),
                );
              },
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text("新しいシート開始 ▶︎"), findsOneWidget);
      expect(find.byType(CalendarNextPillSheetBand), findsOneWidget);
      expect(
          find.byWidgetPredicate((widget) =>
              (widget is CalendarNextPillSheetBand && DateRange.isSameDay(widget.begin, model.begin) && DateRange.isSameDay(widget.end, model.end))),
          findsOneWidget);
    });
    testWidgets('when showing 新しいシート開始 ▶︎ with linebreak', (WidgetTester tester) async {
      /*
  30   31   1   2   3   4   5  

   6    7   8   9  10  11  12  

  13   14  15  16  17  18  19  
                           == 
  20   21  22  23  24  25  26  
  =======
  27   28  29  30  
    */
      var now = DateTime(2020, 09, 14);
      var model = CalendarNextPillSheetBandModel(DateTime(2020, 09, 19), DateTime(2020, 09, 21));
      final diaries = [Diary.fromDate(now)];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diariesForMonthProvider.overrideWith((ref, arg) => Stream.value(diaries)),
            schedulesForMonthProvider.overrideWith((ref, arg) => Stream.value([])),
          ],
          child: MaterialApp(
            home: MonthCalendar(
              dateForMonth: DateTime(2020, 09, 14),
              weekCalendarBuilder: (context, diaries, schedules, weekDateRange) {
                return CalendarWeekLine(
                  dateRange: weekDateRange,
                  calendarMenstruationBandModels: const [],
                  calendarScheduledMenstruationBandModels: const [],
                  calendarNextPillSheetBandModels: [model],
                  horizontalPadding: 0,
                  day: (p0, p1, p2) => Container(),
                );
              },
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text("新しいシート開始 ▶︎"), findsOneWidget);
      expect(find.byType(CalendarNextPillSheetBand), findsNWidgets(2));
      expect(
          find.byWidgetPredicate((widget) =>
              (widget is CalendarNextPillSheetBand && DateRange.isSameDay(widget.begin, model.begin) && DateRange.isSameDay(widget.end, model.end))),
          findsNWidgets(2));
    });
    testWidgets('when showing new sheet label to next month', (WidgetTester tester) async {
      final model = CalendarNextPillSheetBandModel(DateTime(2020, 10, 15), DateTime(2020, 10, 18));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diariesForMonthProvider.overrideWith((ref, arg) => Stream.value([])),
            schedulesForMonthProvider.overrideWith((ref, arg) => Stream.value([])),
          ],
          child: MaterialApp(
            home: MonthCalendar(
              dateForMonth: DateTime(2020, 09, 14),
              weekCalendarBuilder: (context, diaries, schedules, weekDateRange) {
                return CalendarWeekLine(
                  dateRange: weekDateRange,
                  calendarMenstruationBandModels: const [],
                  calendarScheduledMenstruationBandModels: const [],
                  calendarNextPillSheetBandModels: [model],
                  horizontalPadding: 0,
                  day: (p0, p1, p2) => Container(),
                );
              },
            ),
          ),
        ),
      );
      expect(find.text("新しいシート開始 ▶︎"), isNot(findsWidgets));
      expect(find.byType(CalendarNextPillSheetBand), isNot(findsWidgets));
    });
    testWidgets('when showing new sheet label to before month', (WidgetTester tester) async {
      final model = CalendarNextPillSheetBandModel(DateTime(2020, 10, 15), DateTime(2020, 10, 18));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diariesForMonthProvider.overrideWith((ref, arg) => Stream.value([])),
            schedulesForMonthProvider.overrideWith((ref, arg) => Stream.value([])),
          ],
          child: MaterialApp(
            home: MonthCalendar(
              dateForMonth: DateTime(2020, 09, 14),
              weekCalendarBuilder: (context, diaries, schedules, weekDateRange) {
                return CalendarWeekLine(
                  dateRange: weekDateRange,
                  calendarMenstruationBandModels: const [],
                  calendarScheduledMenstruationBandModels: const [],
                  calendarNextPillSheetBandModels: [model],
                  horizontalPadding: 0,
                  day: (p0, p1, p2) => Container(),
                );
              },
            ),
          ),
        ),
      );
      expect(find.text("新しいシート開始 ▶︎"), isNot(findsWidgets));
      expect(find.byType(CalendarNextPillSheetBand), isNot(findsWidgets));
    });
  });
}
