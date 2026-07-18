import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/organisms/pill_mark/pill_marks.dart';
import 'package:pilll/features/appstore_screenshot/mock_screens/mock_components.dart';
import 'package:pilll/features/localizations/l.dart';

/// スクリーンショット用のピルシート画面 Mock（5-A の #2）。論理サイズ 430×932 で描く。
///
/// 本番の RecordPage は Provider 依存が重いため使わず、ピルマークの表示部品
/// （[NormalPillMark] などの円マーク）と本番のテーマ色を組み合わせて
/// 「28錠タイプを16番まで服用済み・17番が今日」の状態を固定データで再現する。
/// 曜日ライン・錠番号まで描いて本番のピルシート UI に寄せる。
///
/// 見出しは [L] 経由の既存ローカライズ文言を使い、曜日ラベルは [lang] で切り替える。
/// フォントファミリーは明示せず、撮影ハーネスが言語ごとに差し替えるテーマを継承する。
class MockRecordScreen extends StatelessWidget {
  const MockRecordScreen({super.key, required this.lang});

  /// 曜日ラベルの言語切替に使う arb 言語コード。
  final String lang;

  /// 今日服用する錠番号。
  static const int _todayPillNumber = 17;

  /// ピルシートの総錠数（28錠タイプ）。
  static const int _totalPillCount = 28;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          _statusBar(),
          _appBar(),
          const SizedBox(height: 28),
          _header(),
          const SizedBox(height: 20),
          _MockPillSheet(lang: lang, todayPillNumber: _todayPillNumber),
          const Spacer(),
          _bottomNavigationBar(),
        ],
      ),
    );
  }

  /// iOS のステータスバー相当。時刻はアップル慣例の 9:41 を使う。
  Widget _statusBar() {
    return SizedBox(
      height: 59,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 18, 32, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('9:41', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: TextColor.main)),
            _battery(),
          ],
        ),
      ),
    );
  }

  /// ステータスバー右のバッテリー表示。
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

  /// 画面上部のアプリバー。左はアプリのワードマーク（ブランド名なので非ローカライズ）。
  Widget _appBar() {
    return Container(
      height: 52,
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Text('Pilll', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: TextColor.primaryDarkBlue)),
          const Spacer(),
          _hamburger(),
        ],
      ),
    );
  }

  /// アプリバー右の設定アフォーダンス（三本線）。
  Widget _hamburger() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (_) => Container(
          width: 20,
          height: 2.5,
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(color: AppColors.gray, borderRadius: BorderRadius.circular(2)),
        ),
      ),
    );
  }

  /// ピルシート上の見出し。「今日飲むピル」＋今日の錠番号チップ（17 / 28）。
  Widget _header() {
    return Column(
      children: [
        Text(
          _stripEmoji(L.todayPillToTake),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: TextColor.main),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(20)),
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: '$_todayPillNumber', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                TextSpan(text: '  /  $_totalPillCount', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.85))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 画面下部のタブバー。記録・カレンダー・生理の 3 タブを模す。
  Widget _bottomNavigationBar() {
    return Container(
      height: 84,
      decoration: const BoxDecoration(color: AppColors.bottomBar, border: Border(top: BorderSide(color: AppColors.border))),
      padding: const EdgeInsets.only(top: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PillCapsule(width: 28, height: 13, color: AppColors.secondary),
          _calendarTab(),
          const CustomPaint(size: Size(26, 24), painter: HeartPainter(color: AppColors.gray)),
        ],
      ),
    );
  }

  /// カレンダータブ。角丸四角に上部の帯を付けてカレンダーを模す。
  Widget _calendarTab() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(border: Border.all(color: AppColors.gray, width: 2), borderRadius: BorderRadius.circular(4)),
      child: Column(children: [Container(height: 6, color: AppColors.gray)]),
    );
  }

  /// 先頭の絵文字（本番文言に含まれる 💊 等）を取り除く。見出しには絵文字を出さない。
  static String _stripEmoji(String text) {
    return text.replaceAll(RegExp(r'[\u{1F000}-\u{1FAFF}\u{2600}-\u{27BF}\u{FE0F}\u{2190}-\u{21FF}]', unicode: true), '').trim();
  }
}

/// ピルシートの見た目を固定データで再現する Mock。曜日ライン・錠番号付き。
class _MockPillSheet extends StatelessWidget {
  const _MockPillSheet({required this.lang, required this.todayPillNumber});

  /// 曜日ラベルの言語切替に使う arb 言語コード。
  final String lang;

  /// 今日服用する錠番号（選択状態で強調する）。
  final int todayPillNumber;

  /// 言語ごとの曜日短縮ラベル（日曜始まり）。未定義言語は en にフォールバックする。
  static const Map<String, List<String>> _weekdayLabels = {
    'ja': ['日', '月', '火', '水', '木', '金', '土'],
    'en': ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
  };

  @override
  Widget build(BuildContext context) {
    final labels = _weekdayLabels[lang] ?? _weekdayLabels['en']!;
    return Container(
      width: 368,
      decoration: BoxDecoration(
        color: AppColors.pillSheet,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8.0, offset: Offset(0, 3))],
      ),
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 26),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var column = 0; column < 7; column++)
                SizedBox(
                  width: 30,
                  child: Center(
                    child: Text(
                      labels[column],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: column == 0
                            ? AppColors.sunday
                            : column == 6
                                ? AppColors.saturday
                                : AppColors.weekday,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          for (var line = 0; line < 4; line++) ...[
            if (line > 0) const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var column = 0; column < 7; column++) _cell(line * 7 + column + 1),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// 錠番号に対応する 1 錠分のセル（マーク＋番号）を返す。
  Widget _cell(int pillNumber) {
    return SizedBox(
      width: 30,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 20, height: 20, child: Center(child: _mark(pillNumber))),
          const SizedBox(height: 3),
          Text('$pillNumber', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: TextColor.gray)),
        ],
      ),
    );
  }

  /// 錠番号の状態に対応するマークを返す。
  /// [todayPillNumber] 未満は服用済み（チェック）、等しければ今日（選択）、
  /// 22番以降は偽薬、それ以外は未服用の実薬。
  Widget _mark(int pillNumber) {
    if (pillNumber < todayPillNumber) {
      return const Stack(
        alignment: Alignment.center,
        children: [LightGrayPillMark(), CustomPaint(size: Size(11, 8.5), painter: CheckPainter(color: AppColors.potti))],
      );
    }
    if (pillNumber == todayPillNumber) {
      return const SelectedPillMark();
    }
    if (pillNumber >= 22) {
      return const FakePillMark();
    }
    return const NormalPillMark();
  }
}
