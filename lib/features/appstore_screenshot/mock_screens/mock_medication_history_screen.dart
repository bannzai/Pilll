import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/appstore_screenshot/mock_screens/mock_components.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_card.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

/// スクリーンショット #7（服用履歴）の Mock。論理サイズ 430×932。
///
/// 実機のカレンダーページを服用履歴カードまでスクロールした状態を、本番
/// [CalendarPillSheetModifiedHistoryCard] と固定データで再現する。
/// 「いつ・何番を飲んだか」が日次で残り、見返して服用漏れを確認できる安心感を訴求する。
/// 履歴の服用番号・日付は MockRecordScreen（今日=16番・7/18）と整合させる。
class MockMedicationHistoryScreen extends StatelessWidget {
  const MockMedicationHistoryScreen({super.key, required this.lang});

  /// 月ラベル・履歴の言語切替に使う arb 言語コード。
  final String lang;

  /// 固定サンプルデータの基準日。他ページの Mock と同じ 7/18(土)。
  static final DateTime _fixedToday = DateTime(2026, 7, 18);

  @override
  Widget build(BuildContext context) {
    // 履歴行の月ヘッダー・時刻表示は intl の DateFormat に依存するため初期化を通す。
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
                        DateTimeFormatter.jaMonth(_fixedToday),
                        // 本番（lib/features/calendar/page.dart）の AppBar title と同系の見た目。
                        style: const TextStyle(color: TextColor.black, fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(left: 16, right: 16),
                children: [
                  CalendarPillSheetModifiedHistoryCard(
                    // 7 件で「もっと見る」ボタン付きの実データらしい見た目にする
                    // （カードは先頭 5 行 + もっと見るを表示する）。
                    histories: mockTakenPillHistories(fixedToday: _fixedToday, count: 7),
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
