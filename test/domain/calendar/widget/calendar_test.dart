import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_next_pill_sheet_band.dart';
import 'package:pilll/domain/calendar/components/month_calendar/month_calendar.dart';
import 'package:pilll/components/organisms/calendar/week/week_calendar.dart';
import 'package:pilll/domain/calendar/components/month_calendar/month_calendar_state.codegen.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    WidgetsBinding.instance.renderView.configuration =
        new TestViewConfiguration(size: const Size(375.0, 667.0));
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
          DateTime(2020, 09, 15), DateTime(2020, 09, 18));
      final diaries = [Diary.fromDate(now)];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            monthCalendarStateProvider.overrideWithProvider(
              (argument) => Provider(
                (_) => AsyncValue.data(
                  MonthCalendarState(
                    dateForMonth: argument,
                    diaries: diaries,
                    menstruations: [],
                  ),
                ),
              ),
            ),
          ],
          child: MaterialApp(
            home: MonthCalendar(
              dateForMonth: DateTime(2020, 09, 14),
              weekCalendarBuilder: (context, monthState, weekState) {
                return CalendarWeekdayLine(
                  state: weekState,
                  calendarMenstruationBandModels: [],
                  calendarScheduledMenstruationBandModels: [],
                  calendarNextPillSheetBandModels: [model],
                  horizontalPadding: 0,
                  onTap: (_, __) => {},
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
              (widget is CalendarNextPillSheetBand &&
                  DateRange.isSameDay(widget.begin, model.begin) &&
                  DateRange.isSameDay(widget.end, model.end))),
          findsOneWidget);
    });
    testWidgets('when showing 新しいシート開始 ▶︎ with linebreak',
        (WidgetTester tester) async {
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
          DateTime(2020, 09, 19), DateTime(2020, 09, 21));
      final diaries = [Diary.fromDate(now)];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            monthCalendarStateProvider.overrideWithProvider(
              (argument) => Provider(
                (_) => AsyncValue.data(
                  MonthCalendarState(
                    dateForMonth: argument,
                    diaries: diaries,
                    menstruations: [],
                  ),
                ),
              ),
            ),
          ],
          child: MaterialApp(
            home: MonthCalendar(
              dateForMonth: DateTime(2020, 09, 14),
              weekCalendarBuilder: (context, monthState, weekState) {
                return CalendarWeekdayLine(
                  state: weekState,
                  calendarMenstruationBandModels: [],
                  calendarScheduledMenstruationBandModels: [],
                  calendarNextPillSheetBandModels: [model],
                  horizontalPadding: 0,
                  onTap: (_, __) => {},
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
              (widget is CalendarNextPillSheetBand &&
                  DateRange.isSameDay(widget.begin, model.begin) &&
                  DateRange.isSameDay(widget.end, model.end))),
          findsNWidgets(2));
    });
    testWidgets('when showing new sheet label to next month',
        (WidgetTester tester) async {
      final model = CalendarNextPillSheetBandModel(
          DateTime(2020, 10, 15), DateTime(2020, 10, 18));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            monthCalendarStateProvider.overrideWithProvider(
              (argument) => Provider(
                (_) => AsyncValue.data(
                  MonthCalendarState(
                    dateForMonth: argument,
                    diaries: [],
                    menstruations: [],
                  ),
                ),
              ),
            ),
          ],
          child: MaterialApp(
            home: MonthCalendar(
              dateForMonth: DateTime(2020, 09, 14),
              weekCalendarBuilder: (context, monthState, weekState) {
                return CalendarWeekdayLine(
                  state: weekState,
                  calendarMenstruationBandModels: [],
                  calendarScheduledMenstruationBandModels: [],
                  calendarNextPillSheetBandModels: [model],
                  horizontalPadding: 0,
                  onTap: (_, __) => {},
                );
              },
            ),
          ),
        ),
      );
      expect(find.text("新しいシート開始 ▶︎"), isNot(findsWidgets));
      expect(find.byType(CalendarNextPillSheetBand), isNot(findsWidgets));
    });
    testWidgets('when showing new sheet label to before month',
        (WidgetTester tester) async {
      final model = CalendarNextPillSheetBandModel(
          DateTime(2020, 10, 15), DateTime(2020, 10, 18));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            monthCalendarStateProvider.overrideWithProvider(
              (argument) => Provider(
                (_) => AsyncValue.data(
                  MonthCalendarState(
                    dateForMonth: argument,
                    diaries: [],
                    menstruations: [],
                  ),
                ),
              ),
            ),
          ],
          child: MaterialApp(
            home: MonthCalendar(
              dateForMonth: DateTime(2020, 09, 14),
              weekCalendarBuilder: (context, monthState, weekState) {
                return CalendarWeekdayLine(
                  state: weekState,
                  calendarMenstruationBandModels: [],
                  calendarScheduledMenstruationBandModels: [],
                  calendarNextPillSheetBandModels: [model],
                  horizontalPadding: 0,
                  onTap: (_, __) => {},
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
