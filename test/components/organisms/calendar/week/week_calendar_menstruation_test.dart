import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_menstruation_band.dart';
import 'package:pilll/components/organisms/calendar/week/week_calendar.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/utils/datetime/date_range.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  group('CalendarWeekLine 生理期間表示', () {
    testWidgets('13日間の生理期間が各週で正しく表示される', (WidgetTester tester) async {
      // 13日間の生理期間（金曜日から開始）
      final menstruation = Menstruation(
        beginDate: DateTime(2025, 1, 10), // 金曜日
        endDate: DateTime(2025, 1, 22), // 水曜日（13日間）
        createdAt: DateTime(2025, 1, 10),
      );
      final model = CalendarMenstruationBandModel(menstruation);

      // 第1週のテスト: 1/5(日) - 1/11(土)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 100,
              child: CalendarWeekLine(
                dateRange: DateRange(
                  DateTime(2025, 1, 5),
                  DateTime(2025, 1, 11),
                ),
                calendarMenstruationBandModels: [model],
                calendarScheduledMenstruationBandModels: const [],
                calendarNextPillSheetBandModels: const [],
                horizontalPadding: 0,
                day: (context, weekday, date) => Expanded(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(child: Text('${date.day}')),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // 第1週には生理バンドが表示されるはず（1/10-1/11の2日間）
      expect(find.byType(CalendarMenstruationBand), findsOneWidget);

      // 第2週のテスト: 1/12(日) - 1/18(土)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 100,
              child: CalendarWeekLine(
                dateRange: DateRange(
                  DateTime(2025, 1, 12),
                  DateTime(2025, 1, 18),
                ),
                calendarMenstruationBandModels: [model],
                calendarScheduledMenstruationBandModels: const [],
                calendarNextPillSheetBandModels: const [],
                horizontalPadding: 0,
                day: (context, weekday, date) => Expanded(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(child: Text('${date.day}')),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // 第2週にも生理バンドが表示されるはず（この週が表示されない問題）
      expect(find.byType(CalendarMenstruationBand), findsOneWidget);

      // 第3週のテスト: 1/19(日) - 1/25(土)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 100,
              child: CalendarWeekLine(
                dateRange: DateRange(
                  DateTime(2025, 1, 19),
                  DateTime(2025, 1, 25),
                ),
                calendarMenstruationBandModels: [model],
                calendarScheduledMenstruationBandModels: const [],
                calendarNextPillSheetBandModels: const [],
                horizontalPadding: 0,
                day: (context, weekday, date) => Expanded(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(child: Text('${date.day}')),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // 第3週にも生理バンドが表示されるはず（1/19-1/22の4日間）
      expect(find.byType(CalendarMenstruationBand), findsOneWidget);
    });

    testWidgets('生理期間が完全に週に含まれる場合の表示', (WidgetTester tester) async {
      // 1週間内に収まる生理期間
      final menstruation = Menstruation(
        beginDate: DateTime(2025, 1, 13), // 月曜日
        endDate: DateTime(2025, 1, 17), // 金曜日（5日間）
        createdAt: DateTime(2025, 1, 13),
      );
      final model = CalendarMenstruationBandModel(menstruation);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 100,
              child: CalendarWeekLine(
                dateRange: DateRange(
                  DateTime(2025, 1, 12),
                  DateTime(2025, 1, 18),
                ),
                calendarMenstruationBandModels: [model],
                calendarScheduledMenstruationBandModels: const [],
                calendarNextPillSheetBandModels: const [],
                horizontalPadding: 0,
                day: (context, weekday, date) => Expanded(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(child: Text('${date.day}')),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CalendarMenstruationBand), findsOneWidget);
    });
  });
}
