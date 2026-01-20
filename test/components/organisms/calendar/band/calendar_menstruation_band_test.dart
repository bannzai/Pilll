import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/components/organisms/calendar/week/week_calendar.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/provider/diary.dart';
import 'package:pilll/provider/schedule.dart';
import 'package:pilll/utils/datetime/date_range.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  group('#calendarMenstruationBandModels 長期間の生理期間表示', () {
    testWidgets('13日間の生理期間が正しく表示される', (WidgetTester tester) async {
      // ユーザーが報告した問題：13日間の生理期間で真ん中の一週間が表示されない
      final menstruation = Menstruation(
        beginDate: DateTime(2025, 1, 10),
        endDate: DateTime(2025, 1, 22), // 13日間
        createdAt: DateTime(2025, 1, 10),
      );
      final model = CalendarMenstruationBandModel(menstruation);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diariesForMonthProvider.overrideWith(
              (ref, arg) => Stream.value([]),
            ),
            schedulesForMonthProvider.overrideWith(
              (ref, arg) => Stream.value([]),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  // 第1週: 1/5 - 1/11
                  _buildWeekWidget(
                    DateRange(DateTime(2025, 1, 5), DateTime(2025, 1, 11)),
                    [model],
                  ),
                  // 第2週: 1/12 - 1/18
                  _buildWeekWidget(
                    DateRange(DateTime(2025, 1, 12), DateTime(2025, 1, 18)),
                    [model],
                  ),
                  // 第3週: 1/19 - 1/25
                  _buildWeekWidget(
                    DateRange(DateTime(2025, 1, 19), DateTime(2025, 1, 25)),
                    [model],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      // 各週で生理期間のバンドが表示されているか確認
      // 第1週: 1/10-1/11 の2日間
      // 第2週: 1/12-1/18 の7日間（この週が表示されない問題）
      // 第3週: 1/19-1/22 の4日間

      // CalendarMenstruationBandが3つ表示されることを確認
      expect(find.byType(CalendarWeekLine), findsNWidgets(3));
    });

    testWidgets('月をまたぐ生理期間が正しく表示される', (WidgetTester tester) async {
      final menstruation = Menstruation(
        beginDate: DateTime(2025, 1, 25),
        endDate: DateTime(2025, 2, 7), // 14日間、月をまたぐ
        createdAt: DateTime(2025, 1, 25),
      );
      final model = CalendarMenstruationBandModel(menstruation);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diariesForMonthProvider.overrideWith(
              (ref, arg) => Stream.value([]),
            ),
            schedulesForMonthProvider.overrideWith(
              (ref, arg) => Stream.value([]),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  // 1月最終週: 1/26 - 2/1
                  _buildWeekWidget(
                    DateRange(DateTime(2025, 1, 26), DateTime(2025, 2, 1)),
                    [model],
                  ),
                  // 2月第1週: 2/2 - 2/8
                  _buildWeekWidget(
                    DateRange(DateTime(2025, 2, 2), DateTime(2025, 2, 8)),
                    [model],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      // 月をまたぐ場合でも正しく表示されることを確認
      expect(find.byType(CalendarWeekLine), findsNWidgets(2));
    });

    testWidgets('4日から13日に編集された生理期間が正しく表示される', (WidgetTester tester) async {
      // ユーザーのシナリオ：最初4日で記録し、後から13日に編集
      final menstruation = Menstruation(
        beginDate: DateTime(2025, 1, 10),
        endDate: DateTime(2025, 1, 22), // 編集後：13日間
        createdAt: DateTime(2025, 1, 10),
      );
      final model = CalendarMenstruationBandModel(menstruation);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diariesForMonthProvider.overrideWith(
              (ref, arg) => Stream.value([]),
            ),
            schedulesForMonthProvider.overrideWith(
              (ref, arg) => Stream.value([]),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    // 全ての週を表示して確認
                    for (var weekStart = DateTime(2025, 1, 5);
                        weekStart.isBefore(DateTime(2025, 1, 26));
                        weekStart = weekStart.add(const Duration(days: 7)))
                      _buildWeekWidget(
                        DateRange(
                          weekStart,
                          weekStart.add(const Duration(days: 6)),
                        ),
                        [model],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      // 編集後の期間が全て表示されることを確認
      expect(find.byType(CalendarWeekLine), findsNWidgets(3));
    });
  });
}

Widget _buildWeekWidget(
  DateRange dateRange,
  List<CalendarMenstruationBandModel> models,
) {
  return SizedBox(
    height: 60,
    child: CalendarWeekLine(
      dateRange: dateRange,
      calendarMenstruationBandModels: models,
      calendarScheduledMenstruationBandModels: const [],
      calendarNextPillSheetBandModels: const [],
      horizontalPadding: 0,
      day: (context, weekday, date) => Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: Center(child: Text('${date.day}')),
      ),
    ),
  );
}
