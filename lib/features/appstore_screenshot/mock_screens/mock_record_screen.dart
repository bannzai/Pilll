import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/appstore_screenshot/mock_screens/mock_components.dart';
import 'package:pilll/features/feature_appeal/menstruation/menstruation_announcement_bar.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/record/components/button/record_page_button.dart';
import 'package:pilll/features/record/components/pill_sheet/record_page_pill_sheet_list.dart';
import 'package:pilll/features/record/components/setting/button.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

/// スクリーンショット用のピルシート画面 Mock（5-A の #2）。論理サイズ 430×932。
///
/// 実機の記録ページ（tmp/real_app/11_home.png）に寄せて固定データで再現する。上部に
/// 「日付」＋「今日飲むピル N番」ヘッダーと本番の [RecordPagePillSheetSettingButton]
/// （「ピルシートの設定」ボタン）、その下に本番の [RecordPagePillSheetList]（[RecordPagePillSheet]
/// による服用済みチェック・送りチェブロン・今日の錠のオレンジリング・日付表示モードと、
/// 複数ピルシート時の [DotsIndicator] ページインジケータを内包する本物の PageView）と
/// 本番の [RecordPageButton]（「飲んだ」ボタン）を配置する。下部は本番同様の 4 タブ。
///
/// [DotsIndicator] は `PageController.page` の参照に実際の `PageView` へのアタッチを要求するため
/// （アタッチ前に参照すると `positions.isNotEmpty` の assertion で例外になる）、単独では使えない。
/// そのため実機同様に 3 ドット出すには、実機のように次以降のピルシートが実在する
/// [PillSheetGroup]（pillSheets 3 枚）を組んで [RecordPagePillSheetList] に委ね、本番の
/// PageView + DotsIndicator の組み合わせをそのまま利用する。
///
/// ヘッダーの日付・番号単位は本番 RecordPageInformationHeader と同じ [DateTimeFormatter]・
/// [L.number] を使う。日付書式は Platform.localeName(=端末言語)由来のため、撮影時は
/// capture_screenshots.sh が言語ごとに Simulator の言語を切り替える(ロケールの日付データは
/// main.dev.dart のカタログ分岐で initializeDateFormatting 済み)。
class MockRecordScreen extends StatelessWidget {
  const MockRecordScreen({super.key, required this.lang});

  /// 日付・曜日・番号単位の言語切替に使う arb 言語コード。
  final String lang;

  /// 今日服用する錠番号。実機（tmp/real_app/11_home.png）の「今日飲むピル 16番」に合わせる。
  static const int todayPillNumber = 16;

  /// 固定サンプルデータの基準日。実機の記録ページスクショ（tmp/real_app/11_home.png）が
  /// 「7/18(土)」なので合わせる（2026-07-18は実際に土曜日）。
  static final DateTime _fixedToday = DateTime(2026, 7, 18);

  @override
  Widget build(BuildContext context) {
    // RecordPagePillSheet は today()/now()（lib/utils/datetime/day.dart）に依存するため固定する。
    applyFixedToday(_fixedToday);

    final pillSheetID = firestoreIDGenerator();
    // 28錠タイプ・today=16番になるよう15日前に開始・15番まで服用済み（=前日まで服用）。
    final pillSheet = PillSheet.v1(
      id: pillSheetID,
      typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
      beginDate: _fixedToday.subtract(const Duration(days: todayPillNumber - 1)),
      lastTakenDate: _fixedToday.subtract(const Duration(days: 1)),
      createdAt: _fixedToday,
    );
    // 実機（tmp/real_app/11_home.png）のページインジケータは3ドット。自動作成設定で次の
    // ピルシートが先読み作成された状態を再現するため、未服用の次シート2枚を続けて生成する。
    final nextPillSheetID = firestoreIDGenerator();
    final nextPillSheet = PillSheet.v1(
      id: nextPillSheetID,
      typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
      beginDate: pillSheet.beginDate.add(Duration(days: PillSheetType.pillsheet_28_0.typeInfo.totalCount)),
      lastTakenDate: null,
      createdAt: _fixedToday,
      groupIndex: 1,
    );
    final secondNextPillSheetID = firestoreIDGenerator();
    final secondNextPillSheet = PillSheet.v1(
      id: secondNextPillSheetID,
      typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
      beginDate: nextPillSheet.beginDate.add(Duration(days: PillSheetType.pillsheet_28_0.typeInfo.totalCount)),
      lastTakenDate: null,
      createdAt: _fixedToday,
      groupIndex: 2,
    );
    final pillSheetGroup = PillSheetGroup(
      pillSheets: [pillSheet, nextPillSheet, secondNextPillSheet],
      createdAt: _fixedToday,
      pillSheetIDs: [pillSheetID, nextPillSheetID, secondNextPillSheetID],
      // 実機（tmp/real_app/11_home.png）はピルマークの上に日付（7/3, 7/4…）を表示するモード。
      pillSheetAppearanceMode: PillSheetAppearanceMode.date,
    );
    const setting = Setting(
      pillNumberForFromMenstruation: 1,
      durationMenstruation: 4,
      reminderTimes: [],
      timezoneDatabaseName: null,
      isOnReminder: true,
    );
    // マーケティング訴求のため、生理予定日ハイライト等が出るプレミアム状態で表示する。
    const user = User(isPremium: true);

    // RecordPagePillSheetSettingButton / RecordPagePillSheet / RecordPageButton は
    // takePillProvider・registerReminderLocalNotificationProvider 等（databaseProvider 経由で
    // FirebaseAuth に触れる）を watch するため ProviderScope で databaseProvider を差し替える。
    // DatabaseConnection のコンストラクタは uid を保持するだけで Firebase に触れない。Firestore
    // アクセスはタップ時のみでスクショではタップしないため呼ばれない。
    return ProviderScope(
      overrides: [
        databaseProvider.overrideWith((ref) => DatabaseConnection('catalog-user')),
      ],
      child: Container(
        color: AppColors.background,
        child: Column(
          children: [
            // 実機は白背景の AppBar(toolbarHeight=130)がステータスバー領域ごと白帯になる。
            Container(
              color: AppColors.white,
              child: Column(
                children: [
                  _statusBar(),
                  _header(),
                ],
              ),
            ),
            MenstruationAnnouncementBar(isClosed: ValueNotifier(false)),
            // 本番（lib/features/record/page.dart）の ListView 先頭の余白と同じ 37。
            const SizedBox(height: 37),
            // 実機（tmp/real_app/11_home.png）の「ピルシートの設定」ボタン。本番の配置
            // （lib/features/record/page.dart）と同じく、ピルシート幅に右寄せする。
            SizedBox(
              width: PillSheetViewLayout.width,
              child: Row(
                children: [
                  const Spacer(),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: RecordPagePillSheetSettingButton(
                        pillSheetGroup: pillSheetGroup,
                        activePillSheet: pillSheet,
                        setting: setting,
                        user: user,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 本番 RecordPagePillSheetList。内部で RecordPagePillSheet（ピルシート本体）と
            // pillSheets が複数の時だけ出す DotsIndicator（実機同様の3ドット）を両方描画する。
            RecordPagePillSheetList(
              pillSheetGroup: pillSheetGroup,
              activePillSheet: pillSheet,
              setting: setting,
              user: user,
            ),
            const Spacer(),
            // 実機の紺色の大ボタン「飲んだ」。本番 RecordPageButton をそのまま使う。
            RecordPageButton(
              pillSheetGroup: pillSheetGroup,
              currentPillSheet: pillSheet,
              userIsPremiumOtTrial: user.premiumOrTrial,
              user: user,
              setting: setting,
            ),
            // 本番（lib/features/record/page.dart）のボタン下余白と同じ 40。
            const SizedBox(height: 40),
            const MockBottomTabBar(activeIndex: 0),
          ],
        ),
      ),
    );
  }

  /// iOS のステータスバー相当。時刻はアップル慣例の 9:41 を使う。
  Widget _statusBar() {
    return SizedBox(
      height: 54,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 18, 32, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('9:41', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: TextColor.main)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _signal(),
                const SizedBox(width: 6),
                _battery(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 電波強度バー（4 本）。
  Widget _signal() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(4, (i) {
        return Container(
          width: 3,
          height: 5.0 + i * 2.5,
          margin: const EdgeInsets.only(left: 1.5),
          decoration: BoxDecoration(color: TextColor.main, borderRadius: BorderRadius.circular(1)),
        );
      }),
    );
  }

  /// バッテリー表示。
  Widget _battery() {
    return Row(
      children: [
        Container(
          width: 24,
          height: 12,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(border: Border.all(color: TextColor.main, width: 1), borderRadius: BorderRadius.circular(3)),
          child: Align(alignment: Alignment.centerLeft, child: Container(width: 15, color: TextColor.main)),
        ),
        Container(width: 2, height: 5, margin: const EdgeInsets.only(left: 1), decoration: const BoxDecoration(color: TextColor.main)),
      ],
    );
  }

  /// 「日付」｜「今日飲むピル N番」ヘッダー。
  ///
  /// 寸法・スタイルは本番 RecordPageInformationHeader（lib/features/record/components/header/
  /// record_page_header.dart, RecordPageInformationHeaderConst.height=130 / 上余白34 /
  /// 日付 24pt w600 TextColor.gray / 縦線 64×10 と左右28 / ラベル 14pt w300 noshime /
  /// 番号 40pt w500）に合わせる。文言だけ言語切替のため固定 Map を使う（class コメント参照）。
  Widget _header() {
    return SizedBox(
      height: 130,
      child: Column(
        children: [
          const SizedBox(height: 34),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                // 本番 RecordPageInformationHeader._todayWidget と同じ組み立て。端末言語切替
                // (capture_screenshots.sh) により全言語で実アプリと同じ書式になる。
                '${DateTimeFormatter.monthAndDay(_fixedToday)} (${DateTimeFormatter.shortWeekday(_fixedToday)})',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: TextColor.gray),
              ),
              const SizedBox(width: 28),
              const SizedBox(height: 64, child: VerticalDivider(width: 10, color: AppColors.divider)),
              const SizedBox(width: 28),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(L.todayPillToTake, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: TextColor.noshime)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      const Text('$todayPillNumber', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500, color: TextColor.main)),
                      Text(
                        // 本番 TodayTakenPillNumber と同じ単位文言(L.number)。
                        L.number,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: TextColor.main),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
