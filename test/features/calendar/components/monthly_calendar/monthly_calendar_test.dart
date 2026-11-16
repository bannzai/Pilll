import 'package:flutter/rendering.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_next_pill_sheet_band.dart';
import 'package:pilll/features/calendar/components/month_calendar/month_calendar.dart';
import 'package:pilll/components/organisms/calendar/week/week_calendar.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/datetime/date_range.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/features/record/weekday_badge.dart';
import 'package:pilll/provider/diary.dart';
import 'package:pilll/provider/first_weekday.dart';
import 'package:pilll/provider/schedule.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    for (var element in RendererBinding.instance.renderViews) {
      element.configuration = TestViewConfiguration.fromView(
        view: WidgetsBinding.instance.platformDispatcher.views.single,
        size: const Size(375.0, 667.0),
      );
    }
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
      var model = CalendarNextPillSheetBandModel(
        DateTime(2020, 09, 15),
        DateTime(2020, 09, 18),
      );
      final diaries = [Diary.fromDate(now)];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diariesForMonthProvider.overrideWith(
              (ref, arg) => Stream.value(diaries),
            ),
            schedulesForMonthProvider.overrideWith(
              (ref, arg) => Stream.value([]),
            ),
            firstWeekdayProvider.overrideWithValue(Weekday.Sunday),
          ],
          child: MaterialApp(
            home: MonthCalendar(
              dateForMonth: DateTime(2020, 09, 14),
              weekCalendarBuilder:
                  (context, diaries, schedules, weekDateRange) {
                return CalendarWeekLine(
                  dateRange: weekDateRange,
                  calendarMenstruationBandModels: const [],
                  calendarScheduledMenstruationBandModels: const [],
                  calendarNextPillSheetBandModels: [model],
                  day: (p0, p1, p2) => Container(),
                );
              },
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text(L.newPillSheetStart), findsOneWidget);
      expect(find.byType(CalendarNextPillSheetBand), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) => (widget is CalendarNextPillSheetBand &&
              DateRange.isSameDay(widget.begin, model.begin) &&
              DateRange.isSameDay(widget.end, model.end)),
        ),
        findsOneWidget,
      );
    });
    testWidgets('when showing 新しいシート開始 ▶︎ with linebreak', (
      WidgetTester tester,
    ) async {
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
      var model = CalendarNextPillSheetBandModel(
        DateTime(2020, 09, 19),
        DateTime(2020, 09, 21),
      );
      final diaries = [Diary.fromDate(now)];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diariesForMonthProvider.overrideWith(
              (ref, arg) => Stream.value(diaries),
            ),
            schedulesForMonthProvider.overrideWith(
              (ref, arg) => Stream.value([]),
            ),
            firstWeekdayProvider.overrideWithValue(Weekday.Sunday),
          ],
          child: MaterialApp(
            home: MonthCalendar(
              dateForMonth: DateTime(2020, 09, 14),
              weekCalendarBuilder:
                  (context, diaries, schedules, weekDateRange) {
                return CalendarWeekLine(
                  dateRange: weekDateRange,
                  calendarMenstruationBandModels: const [],
                  calendarScheduledMenstruationBandModels: const [],
                  calendarNextPillSheetBandModels: [model],
                  day: (p0, p1, p2) => Container(),
                );
              },
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text(L.newPillSheetStart), findsOneWidget);
      expect(find.byType(CalendarNextPillSheetBand), findsNWidgets(2));
      expect(
        find.byWidgetPredicate(
          (widget) => (widget is CalendarNextPillSheetBand &&
              DateRange.isSameDay(widget.begin, model.begin) &&
              DateRange.isSameDay(widget.end, model.end)),
        ),
        findsNWidgets(2),
      );
    });
    testWidgets('when showing new sheet label to next month', (
      WidgetTester tester,
    ) async {
      final model = CalendarNextPillSheetBandModel(
        DateTime(2020, 10, 15),
        DateTime(2020, 10, 18),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diariesForMonthProvider.overrideWith(
              (ref, arg) => Stream.value([]),
            ),
            schedulesForMonthProvider.overrideWith(
              (ref, arg) => Stream.value([]),
            ),
            firstWeekdayProvider.overrideWithValue(Weekday.Sunday),
          ],
          child: MaterialApp(
            home: MonthCalendar(
              dateForMonth: DateTime(2020, 09, 14),
              weekCalendarBuilder:
                  (context, diaries, schedules, weekDateRange) {
                return CalendarWeekLine(
                  dateRange: weekDateRange,
                  calendarMenstruationBandModels: const [],
                  calendarScheduledMenstruationBandModels: const [],
                  calendarNextPillSheetBandModels: [model],
                  day: (p0, p1, p2) => Container(),
                );
              },
            ),
          ),
        ),
      );
      expect(find.text(L.newPillSheetStart), isNot(findsWidgets));
      expect(find.byType(CalendarNextPillSheetBand), isNot(findsWidgets));
    });
    testWidgets('when showing new sheet label to before month', (
      WidgetTester tester,
    ) async {
      final model = CalendarNextPillSheetBandModel(
        DateTime(2020, 10, 15),
        DateTime(2020, 10, 18),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diariesForMonthProvider.overrideWith(
              (ref, arg) => Stream.value([]),
            ),
            schedulesForMonthProvider.overrideWith(
              (ref, arg) => Stream.value([]),
            ),
            firstWeekdayProvider.overrideWithValue(Weekday.Sunday),
          ],
          child: MaterialApp(
            home: MonthCalendar(
              dateForMonth: DateTime(2020, 09, 14),
              weekCalendarBuilder:
                  (context, diaries, schedules, weekDateRange) {
                return CalendarWeekLine(
                  dateRange: weekDateRange,
                  calendarMenstruationBandModels: const [],
                  calendarScheduledMenstruationBandModels: const [],
                  calendarNextPillSheetBandModels: [model],
                  day: (p0, p1, p2) => Container(),
                );
              },
            ),
          ),
        ),
      );
      expect(find.text(L.newPillSheetStart), isNot(findsWidgets));
      expect(find.byType(CalendarNextPillSheetBand), isNot(findsWidgets));
    });
  });

  group("CalendarNextPillSheetBand", () {
    /*
    週の始まりが月曜日の 2020-09
  31    1   2   3   4   5   6

   7    8   9  10  11  12  13

  14   15  16  17  18  19  20

  21   22  23  24  25  26  27

  28   29  30
    */
    Future<void> pumpMondayStartMonthCalendar(WidgetTester tester, {required CalendarNextPillSheetBandModel model}) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diariesForMonthProvider.overrideWith((ref, arg) => Stream.value([])),
            schedulesForMonthProvider.overrideWith((ref, arg) => Stream.value([])),
            firstWeekdayProvider.overrideWithValue(Weekday.Monday),
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
                  day: (context, weekday, date) => Expanded(child: Container()),
                );
              },
            ),
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('週の始まりが月曜日の時、土曜日から火曜日の帯は日曜日の後で折り返し、土日の 2 日分と月火の 2 日分に分かれる', (WidgetTester tester) async {
      await pumpMondayStartMonthCalendar(
        tester,
        model: CalendarNextPillSheetBandModel(DateTime(2020, 09, 19), DateTime(2020, 09, 22)),
      );

      final bands = tester.widgetList<CalendarNextPillSheetBand>(find.byType(CalendarNextPillSheetBand)).toList();
      expect(bands.map((band) => band.isLineBreak).toList(), [false, true]);
      // 日曜日始まりなら土曜日の 1 日分と日月火の 3 日分に分かれるため、幅が同じにならない
      expect(bands.first.width, closeTo(bands.last.width, 0.01));
      // 1 つ目の帯は左端から 5 列目 (土曜日) から、折り返した帯は左端 (月曜日) から始まる。1 列の幅は 2 日分の帯の幅の半分
      expect(
        tester.getTopLeft(find.byType(CalendarNextPillSheetBand).first).dx - tester.getTopLeft(find.byType(CalendarNextPillSheetBand).last).dx,
        closeTo(5 * bands.first.width / 2, 0.01),
      );
    });

    testWidgets('週の始まりが月曜日の時、日曜日から月曜日の帯は日曜日が行の右端に入り、月曜日が次の行の左端に折り返す', (WidgetTester tester) async {
      await pumpMondayStartMonthCalendar(
        tester,
        model: CalendarNextPillSheetBandModel(DateTime(2020, 09, 20), DateTime(2020, 09, 21)),
      );

      // 日曜日始まりなら同じ行の左端 2 列に収まり、帯は 1 つになる
      final bands = tester.widgetList<CalendarNextPillSheetBand>(find.byType(CalendarNextPillSheetBand)).toList();
      expect(bands.map((band) => band.isLineBreak).toList(), [false, true]);
      expect(bands.first.width, closeTo(bands.last.width, 0.01));
      // 1 つ目の帯は左端から 6 列目 (日曜日) の 1 日分、折り返した帯は左端 (月曜日) の 1 日分
      expect(
        tester.getTopLeft(find.byType(CalendarNextPillSheetBand).first).dx - tester.getTopLeft(find.byType(CalendarNextPillSheetBand).last).dx,
        closeTo(6 * bands.first.width, 0.01),
      );
    });
  });

  group("WeekdayBadge", () {
    for (final firstWeekday in [Weekday.Sunday, Weekday.Monday]) {
      testWidgets('週の始まりが $firstWeekday の時、曜日の行が $firstWeekday から並び、各列の日付の曜日が見出しの曜日と一致する', (WidgetTester tester) async {
        final dayTileWeekdays = <DateTime, Weekday>{};

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              diariesForMonthProvider.overrideWith((ref, arg) => Stream.value([])),
              schedulesForMonthProvider.overrideWith((ref, arg) => Stream.value([])),
              firstWeekdayProvider.overrideWithValue(firstWeekday),
            ],
            child: MaterialApp(
              home: MonthCalendar(
                dateForMonth: DateTime(2020, 09, 14),
                weekCalendarBuilder: (context, diaries, schedules, weekDateRange) {
                  return CalendarWeekLine(
                    dateRange: weekDateRange,
                    calendarMenstruationBandModels: const [],
                    calendarScheduledMenstruationBandModels: const [],
                    calendarNextPillSheetBandModels: const [],
                    day: (context, weekday, date) {
                      dayTileWeekdays[date] = weekday;
                      return Expanded(child: Container());
                    },
                  );
                },
              ),
            ),
          ),
        );
        await tester.pump();

        expect(
          tester.widgetList<WeekdayBadge>(find.byType(WeekdayBadge)).map((weekdayBadge) => weekdayBadge.weekday).toList(),
          WeekdayFunctions.weekdaysForFirstWeekday(firstWeekday),
        );
        // 2020-09 の全ての日 (30 日) と 1 行目の前月の日が、実際の曜日で描画される
        expect(dayTileWeekdays.keys.where((date) => date.month == 9).length, 30);
        expect(dayTileWeekdays.entries.every((entry) => entry.value == WeekdayFunctions.weekdayFromDate(entry.key)), isTrue);
        expect(dayTileWeekdays[DateTime(2020, 9, 13)], Weekday.Sunday);
        expect(dayTileWeekdays[DateTime(2020, 9, 14)], Weekday.Monday);
        // 1 行目の列の並びが見出しと同じ曜日の順になる (2020-09-01 は火曜日なので、1 行目は月曜日始まりで 08-31、日曜日始まりで 08-30 から)
        expect(dayTileWeekdays.values.take(Weekday.values.length).toList(), WeekdayFunctions.weekdaysForFirstWeekday(firstWeekday));
        expect(dayTileWeekdays.keys.first, firstWeekday == Weekday.Monday ? DateTime(2020, 8, 31) : DateTime(2020, 8, 30));
      });
    }
  });
}
