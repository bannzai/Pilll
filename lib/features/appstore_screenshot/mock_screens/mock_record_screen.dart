import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/appstore_screenshot/mock_screens/mock_components.dart';
import 'package:pilll/features/localizations/l.dart';

/// スクリーンショット用のピルシート画面 Mock（5-A の #2）。論理サイズ 430×932。
///
/// 実機の記録ページ（tmp/research/screenshots/pilll/jp/01.png）に寄せて固定データで
/// 再現する。上部に「日付」＋「今日飲むピル N番」ヘッダーと「服用お休み」ボタン、
/// その下に月曜始まりの曜日ライン・錠番号付きピルシート（服用済みチェック＋送りチェブロン、
/// 今日の錠はオレンジリング）を描く。下部は本番同様の 4 タブ。
///
/// 本番の RecordPagePillSheet は PillSheetGroup / Setting / 各種 Provider に強く依存するため、
/// テストで安定して撮るには配線が重い。ここでは同じ見た目を固定データで再構成する。
/// 見出しは [L] の既存ローカライズ文言、日付・番号単位・曜日は [lang] で切り替える。
class MockRecordScreen extends StatelessWidget {
  const MockRecordScreen({super.key, required this.lang});

  /// 日付・曜日・番号単位の言語切替に使う arb 言語コード。
  final String lang;

  /// 今日服用する錠番号。
  static const int todayPillNumber = 16;

  /// 言語ごとの日付表記（固定の見本日 1/12 火曜）。
  static const Map<String, String> _dateLabel = {'ja': '1/12 (火)', 'en': 'Tue, Jan 12'};

  /// 言語ごとの錠番号の単位。ja は「番」、en は単位なし。
  static const Map<String, String> _pillNumberUnit = {'ja': '番', 'en': ''};

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          _statusBar(),
          const SizedBox(height: 8),
          _header(),
          const SizedBox(height: 12),
          _restButton(),
          const SizedBox(height: 24),
          _MockPillSheet(lang: lang, todayPillNumber: todayPillNumber),
          const Spacer(),
          const MockBottomTabBar(activeIndex: 0),
        ],
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

  /// 「日付」｜「今日飲むピル N番」ヘッダー。実機の記録ページ上部に対応。
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _dateLabel[lang] ?? _dateLabel['en']!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: TextColor.main),
            ),
          ),
          Container(width: 1, height: 56, color: AppColors.divider),
          Expanded(
            child: Column(
              children: [
                Text(L.todayPillToTake, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: TextColor.main)),
                const SizedBox(height: 2),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: '$todayPillNumber', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: TextColor.main)),
                      TextSpan(
                        text: _pillNumberUnit[lang] ?? _pillNumberUnit['en']!,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: TextColor.main),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 「服用お休み」ボタン（アウトライン、右寄せ）。
  Widget _restButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary, width: 1.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(L.pauseTaking, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

/// 実機のピルシート表示を固定データで再現する Mock。
/// 月曜始まりの曜日ライン、錠番号（マーク上）、服用済みチェック＋送りチェブロン、
/// 今日の錠のオレンジリングを描く。
class _MockPillSheet extends StatelessWidget {
  const _MockPillSheet({required this.lang, required this.todayPillNumber});

  /// 曜日ラベルの言語切替に使う arb 言語コード。
  final String lang;

  /// 今日服用する錠番号（オレンジリングで強調）。
  final int todayPillNumber;

  /// 月曜始まりの曜日短縮ラベル。実機 01.png に合わせて月曜始まり。
  static const Map<String, List<String>> _weekdayLabels = {
    'ja': ['月', '火', '水', '木', '金', '土', '日'],
    'en': ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
  };

  @override
  Widget build(BuildContext context) {
    final labels = _weekdayLabels[lang] ?? _weekdayLabels['en']!;
    return Container(
      width: 372,
      decoration: BoxDecoration(
        color: AppColors.pillSheet,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8.0, offset: Offset(0, 3))],
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var column = 0; column < 7; column++)
                SizedBox(
                  width: 40,
                  child: Center(
                    child: Text(
                      labels[column],
                      // 月曜始まりなので index 5=土(青), 6=日(赤)。
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: column == 5
                            ? AppColors.saturday
                            : column == 6
                                ? AppColors.sunday
                                : AppColors.weekday,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          for (var line = 0; line < 4; line++) ...[
            if (line > 0) const SizedBox(height: 8),
            _pillLine(line),
          ],
        ],
      ),
    );
  }

  /// 1 行（7 錠）を、送りチェブロンを挟みつつ組む。
  Widget _pillLine(int line) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var column = 0; column < 7; column++) ...[
          if (column > 0) _chevron(line * 7 + column),
          _cell(line * 7 + column + 1),
        ],
      ],
    );
  }

  /// セル間の送りチェブロン。左隣の錠が服用済み（今日より前）のときだけ出す。
  Widget _chevron(int leftPillNumber) {
    return SizedBox(
      width: 10,
      child: leftPillNumber < todayPillNumber ? const Center(child: CustomPaint(size: Size(7, 10), painter: ChevronPainter(color: AppColors.lightGray))) : null,
    );
  }

  /// 1 錠分のセル（番号＋マーク）。
  Widget _cell(int pillNumber) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$pillNumber', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: TextColor.gray)),
        const SizedBox(height: 3),
        _mark(pillNumber),
      ],
    );
  }

  /// 錠番号の状態に対応するマーク。
  /// 今日より前＝服用済み（薄灰＋チェック）、今日＝薄灰＋オレンジリング、
  /// 22番以降＝偽薬（白）、それ以外＝未服用の実薬（青灰）。
  Widget _mark(int pillNumber) {
    if (pillNumber < todayPillNumber) {
      return Container(
        width: 22,
        height: 22,
        decoration: const BoxDecoration(color: AppColors.lightGray, shape: BoxShape.circle),
        child: const Center(child: CustomPaint(size: Size(11, 8.5), painter: CheckPainter(color: Colors.white))),
      );
    }
    if (pillNumber == todayPillNumber) {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.secondary, width: 2.5),
        ),
      );
    }
    if (pillNumber >= 22) {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(color: AppColors.blank, shape: BoxShape.circle, border: Border.all(color: AppColors.border)),
      );
    }
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(color: AppColors.potti, shape: BoxShape.circle),
    );
  }
}
