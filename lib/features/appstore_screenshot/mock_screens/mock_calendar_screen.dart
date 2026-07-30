import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/components/organisms/calendar/day/calendar_day_tile.dart';
import 'package:pilll/components/organisms/calendar/week/utility.dart';
import 'package:pilll/components/organisms/calendar/week/week_calendar.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/features/appstore_screenshot/mock_screens/mock_components.dart';
import 'package:pilll/features/calendar/components/const.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_card.dart';
import 'package:pilll/features/record/weekday_badge.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

/// スクリーンショット #6（カレンダー）の Mock。論理サイズ 430×932。
///
/// 実機のカレンダーページ（lib/features/calendar/page.dart）と同じ構成を、本番コンポーネントを
/// そのまま使って固定データで再現する。
/// - 月間カレンダー: 本番 MonthCalendar と同じ組み立て（WeekdayBadge 行 + 週数分の
///   [CalendarWeekLine]）。diary/schedule は Provider(Firestore) 依存のため空で固定する
/// - バンド: 直近の生理(実績)・生理予定日・次のピルシート開始日を本番の band で表示する。
///   日付は MockRecordScreen(16番=7/3開始・28錠)・MockMenstruationScreen(予定日7/25)と整合させる
/// - 下部: 本番 [CalendarPillSheetModifiedHistoryCard]（服用履歴カード）の冒頭が覗く
class MockCalendarScreen extends StatelessWidget {
  const MockCalendarScreen({super.key, required this.lang});

  /// 月ラベル・曜日・履歴の言語切替に使う arb 言語コード。
  final String lang;

  /// 固定サンプルデータの基準日。他ページの Mock と同じ 7/18(土)。
  static final DateTime _fixedToday = DateTime(2026, 7, 18);

  /// 表示する月（2026年7月）。
  static final DateTime _displayedMonth = DateTime(2026, 7, 1);

  /// 直近の生理実績。MockMenstruationScreen の履歴先頭（6/27〜6/30）と同じ。
  static final Menstruation _latestMenstruation = Menstruation(
    beginDate: DateTime(2026, 6, 27),
    endDate: DateTime(2026, 6, 30),
    createdAt: DateTime(2026, 6, 27),
  );

  /// 生理予定日（7/25〜7/28）。MockMenstruationScreen の予定日と同じ。
  static final CalendarScheduledMenstruationBandModel _scheduledBand =
      CalendarScheduledMenstruationBandModel(DateTime(2026, 7, 25), DateTime(2026, 7, 28));

  /// 次のピルシート開始日。MockRecordScreen の 28 錠シート（7/3 開始）の次シート初日 7/31。
  static final CalendarNextPillSheetBandModel _nextPillSheetBand = CalendarNextPillSheetBandModel(DateTime(2026, 7, 31), DateTime(2026, 7, 31));

  @override
  Widget build(BuildContext context) {
    // CalendarDayTile 等は today()（lib/utils/datetime/day.dart）で今日ハイライトを決めるため固定する。
    applyFixedToday(_fixedToday);

    // 履歴行は setPillSheetModifiedHistoryProvider（databaseProvider 経由で FirebaseAuth に触れる）を
    // watch するため差し替える。DatabaseConnection のコンストラクタは uid を保持するだけで
    // Firebase に触れない。Firestore アクセスはタップ時のみでスクショではタップしないため呼ばれない。
    return ProviderScope(
      overrides: [
        databaseProvider.overrideWith((ref) => DatabaseConnection('catalog-user')),
      ],
      child: Container(
        color: AppColors.background,
        child: Column(
          children: [
            // 実機の AppBar 相当。ステータスバー領域ごと白背景（本番は AppBar が白）。
            Container(
              color: AppColors.white,
              child: Column(
                children: [
                  _statusBar(),
                  SizedBox(
                    // 本番 AppBar の既定 toolbar 高。
                    height: kToolbarHeight,
                    child: Center(
                      child: Text(
                        DateTimeFormatter.jaMonth(_displayedMonth),
                        // 本番（lib/features/calendar/page.dart）の AppBar title と同系の見た目。
                        style: const TextStyle(color: TextColor.black, fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _monthCalendar(),
            // 本番カレンダーページの月間カレンダーと履歴カードの間隔と同じ 30。
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(left: 16, right: 16),
                children: [
                  CalendarPillSheetModifiedHistoryCard(
                    histories: mockTakenPillHistories(fixedToday: _fixedToday, count: 3),
                    // マーケティング訴求のため、履歴が伏せられないプレミアム状態で表示する。
                    user: const User(isPremium: true),
                  ),
                ],
              ),
            ),
            const MockBottomTabBar(activeIndex: 2),
          ],
        ),
      ),
    );
  }

  /// 本番 MonthCalendar と同じ月間グリッド。Provider(Firestore) を通さず固定データで組む。
  Widget _monthCalendar() {
    final weekDateRanges = List.generate(
      WeekCalendarDateRangeCalculator(_displayedMonth).weeklineCount(),
      (index) => WeekCalendarDateRangeCalculator(_displayedMonth).dateRangeOfLine(index + 1),
    );
    return Container(
      // 本番 MonthCalendarPager と同じ白背景 + 下方向の影。
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6.0, offset: const Offset(0, 2))],
      ),
      // CalendarWeekLine はバンド幅の計算に MediaQuery.size を使うため、Mock の論理幅 430 に固定する。
      child: MediaQuery(
        data: const MediaQueryData(size: Size(430, 932)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                Weekday.values.length,
                (index) => Expanded(child: WeekdayBadge(weekday: Weekday.values[index])),
              ),
            ),
            const Divider(height: 1),
            ...weekDateRanges.map(
              (weekDateRange) => Column(
                children: [
                  SizedBox(
                    height: CalendarConstants.tileHeight,
                    child: CalendarWeekLine(
                      dateRange: weekDateRange,
                      calendarMenstruationBandModels: [CalendarMenstruationBandModel(_latestMenstruation)],
                      calendarScheduledMenstruationBandModels: [_scheduledBand],
                      calendarNextPillSheetBandModels: [_nextPillSheetBand],
                      horizontalPadding: 0,
                      day: (context, weekday, date) {
                        if (date.isPreviousMonth(_displayedMonth)) {
                          return CalendarDayTile.grayout(weekday: weekday, date: date);
                        }
                        return CalendarDayTile(weekday: weekday, date: date, diary: null, schedule: null, onTap: null);
                      },
                    ),
                  ),
                  const Divider(height: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// iOS のステータスバー相当。
  Widget _statusBar() {
    return const SizedBox(
      height: 54,
      child: Padding(
        padding: EdgeInsets.fromLTRB(32, 18, 32, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('9:41', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: TextColor.main)),
            Text('', style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
