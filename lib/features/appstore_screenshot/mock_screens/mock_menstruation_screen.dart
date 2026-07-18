import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/appstore_screenshot/mock_screens/mock_components.dart';
import 'package:pilll/features/menstruation/components/calendar/menstruation_calendar_header.dart';
import 'package:pilll/features/menstruation/components/menstruation_record_button.dart';
import 'package:pilll/features/menstruation/data.dart';
import 'package:pilll/features/menstruation/menstruation_card.dart';
import 'package:pilll/features/menstruation/menstruation_card_state.codegen.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

/// スクリーンショット #5（生理管理）の Mock。論理サイズ 430×932。
///
/// 実機の生理ページ（tmp/real_app/13_menst.png）と同じ構成を、本番コンポーネントを
/// そのまま使って固定データで再現する。
/// - 週カレンダー: 本番 [MenstruationCalendarHeader]（band 一覧・diary・schedule を引数で
///   受け取る作りなので、Provider を経由せず固定データを直接渡せる）
/// - 生理予定日カード: 本番 [MenstruationCard]。配置は本番 MenstruationCardList の
///   ListView（padding top16 / horizontal16・カードは横幅いっぱい）と同じにする
/// - 「生理を記録」ボタン: 本番 [MenstruationRecordButton]
/// - 上部は実機の AppBar 相当（白背景・中央に月ラベル）＋ステータスバー
class MockMenstruationScreen extends StatelessWidget {
  const MockMenstruationScreen({super.key, required this.lang});

  /// 曜日・月・日付ラベルの言語切替に使う arb 言語コード。
  final String lang;

  /// 固定サンプルデータの基準日（土曜）。実機の生理ページスクショ（tmp/real_app/13_menst.png）が
  /// 「7/18(土)」週表示なので合わせる（[MockRecordScreen] の基準日と同じ）。
  static final DateTime _fixedToday = DateTime(2026, 7, 18);

  /// 生理予定日。訴求画像内で日付と残り日数を読み取りやすい7日後に固定する。
  static final DateTime _scheduledMenstruationBegin = _fixedToday.add(const Duration(days: 7));

  @override
  Widget build(BuildContext context) {
    // MenstruationCalendarHeader/MenstruationCard は today()（lib/utils/datetime/day.dart）と
    // intl の DateFormat（Platform.localeName）に依存するため固定・初期化する。
    applyFixedToday(_fixedToday);

    const setting = Setting(
      pillNumberForFromMenstruation: 1,
      durationMenstruation: 4,
      reminderTimes: [],
      timezoneDatabaseName: null,
      isOnReminder: true,
    );

    final scheduledBands = [
      CalendarScheduledMenstruationBandModel(_scheduledMenstruationBegin, _scheduledMenstruationBegin.add(const Duration(days: 3))),
    ];

    return ProviderScope(
      // MenstruationRecordButton は beginMenstruationProvider（databaseProvider 経由）を watch する。
      // DatabaseConnection のコンストラクタは uid を保持するだけで Firebase に触れない。
      // Firestore アクセスはタップ時のみでスクショではタップしないため呼ばれない。
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
                        DateTimeFormatter.jaMonth(_fixedToday),
                        // 本番（lib/features/menstruation/page.dart）の AppBar title と同じ
                        // TextColor.black。サイズは M2 AppBar 既定の titleTextStyle 相当。
                        style: const TextStyle(color: TextColor.black, fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            MenstruationCalendarHeader(
              pageController: PageController(initialPage: todayCalendarPageIndex),
              calendarMenstruationBandModels: const [],
              calendarNextPillSheetBandModels: const [],
              calendarScheduledMenstruationBandModels: scheduledBands,
              diaries: const [],
              schedules: const [],
            ),
            // 本番 MenstruationCardList と同じ配置（Expanded + ListView、padding top16/横16、
            // カードは横幅いっぱい）。cardState はピルシートからの予測計算を要求するため、
            // 表示状態を固定できる MenstruationCardState.future を直接渡す。
            Expanded(
              child: Container(
                color: AppColors.background,
                child: ListView(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  children: [
                    MenstruationCard(MenstruationCardState.future(nextSchedule: _scheduledMenstruationBegin)),
                  ],
                ),
              ),
            ),
            const MenstruationRecordButton(latestMenstruation: null, setting: setting),
            // 本番（lib/features/menstruation/page.dart）のボタン下余白と同じ 20。
            const SizedBox(height: 20),
            const MockBottomTabBar(activeIndex: 1),
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
