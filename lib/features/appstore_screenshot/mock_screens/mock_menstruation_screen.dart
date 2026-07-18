import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/appstore_screenshot/mock_screens/mock_components.dart';
import 'package:pilll/features/localizations/l.dart';

/// スクリーンショット #5（生理管理）の Mock。論理サイズ 430×932。
///
/// 実機の生理ページ（tmp/research/screenshots/pilll/jp/04.png）に寄せて固定データで
/// 再現する。週カレンダー（日曜始まり・今日を濃紺の丸）＋生理予定期間のピンク斜線帯、
/// 「生理予定日 1/21(火)」＋「あと1日」バッジのカード、「生理を記録」ボタン、下部 4 タブ。
/// 見出し・日数・ボタンは [L] の既存ローカライズ文言、曜日・月・日付は [lang] で切り替える。
class MockMenstruationScreen extends StatelessWidget {
  const MockMenstruationScreen({super.key, required this.lang});

  /// 曜日・月・日付ラベルの言語切替に使う arb 言語コード。
  final String lang;

  /// 今日から生理予定日までの残り日数。
  static const int _remainingDays = 1;

  /// 週カレンダーに表示する日付（日曜始まりの 1 週間）。
  static const List<int> _dates = [20, 21, 22, 23, 24, 25, 26];

  /// 今日の日付。
  static const int _today = 20;

  /// 言語ごとの曜日短縮ラベル（日曜始まり）。未定義言語は en にフォールバック。
  static const Map<String, List<String>> _weekdayLabels = {
    'ja': ['日', '月', '火', '水', '木', '金', '土'],
    'en': ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
  };

  /// 言語ごとの月ラベル。
  static const Map<String, String> _monthLabel = {'ja': '1月', 'en': 'January'};

  /// 言語ごとの「今日」ラベル。
  static const Map<String, String> _todayLabel = {'ja': '今日', 'en': 'Today'};

  /// 言語ごとの生理予定日の日付。
  static const Map<String, String> _scheduleDate = {'ja': '1/21 (火)', 'en': 'Tue, Jan 21'};

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          _statusBar(),
          const SizedBox(height: 8),
          _weekCalendar(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _scheduleCard(),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _recordButton(),
          ),
          const SizedBox(height: 24),
          const MockBottomTabBar(activeIndex: 1),
        ],
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

  /// 週カレンダー（月ラベル・今日・曜日・日付＋生理予定のピンク斜線帯）。
  Widget _weekCalendar() {
    final labels = _weekdayLabels[lang] ?? _weekdayLabels['en']!;
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              Text(_monthLabel[lang] ?? _monthLabel['en']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: TextColor.main)),
              const Spacer(),
              Text(_todayLabel[lang] ?? _todayLabel['en']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.secondary)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < 7; i++)
                SizedBox(
                  width: 36,
                  child: Center(
                    child: Text(
                      labels[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: i == 0
                            ? AppColors.sunday
                            : i == 6
                                ? AppColors.saturday
                                : AppColors.weekday,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < 7; i++) _dateCircle(_dates[i], isSaturday: i == 6),
            ],
          ),
          const SizedBox(height: 10),
          // 生理予定期間のピンク斜線帯。
          const CustomPaint(size: Size(double.infinity, 14), painter: _DiagonalStripesPainter()),
        ],
      ),
    );
  }

  /// 日付の丸。今日は濃紺の塗り、それ以外は素の数字（土曜は青）。
  Widget _dateCircle(int date, {required bool isSaturday}) {
    return SizedBox(
      width: 36,
      child: Center(
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(color: date == _today ? AppColors.primary : Colors.transparent, shape: BoxShape.circle),
          child: Center(
            child: Text(
              '$date',
              style: TextStyle(
                fontSize: 16,
                fontWeight: date == _today ? FontWeight.w700 : FontWeight.w500,
                color: date == _today
                    ? Colors.white
                    : isSaturday
                        ? AppColors.saturday
                        : TextColor.main,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 「生理予定日 1/21(火)」＋「あと1日」バッジのカード。
  Widget _scheduleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          // 訳語が長いロケールでカード幅を超えないよう、はみ出す場合のみ全体を縮小する
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomPaint(size: Size(18, 22), painter: TeardropPainter(color: AppColors.menstruation)),
                const SizedBox(width: 12),
                Text(L.menstruationScheduleDate, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: TextColor.main)),
                const SizedBox(width: 14),
                Text(_scheduleDate[lang] ?? _scheduleDate['en']!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: TextColor.main)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(14)),
            child: Text(L.menstruationRemainingDay(_remainingDays), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// 「生理を記録」ボタン（濃紺の塗り）。
  Widget _recordButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(24)),
      child: Center(
        child: Text(L.recordMenstruation, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
      ),
    );
  }
}

/// 生理予定期間を表すピンクの斜線帯を描く。
class _DiagonalStripesPainter extends CustomPainter {
  const _DiagonalStripesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.menstruation.withValues(alpha: 0.18));
    final linePaint = Paint()
      ..color = AppColors.menstruation
      ..strokeWidth = 2;
    // 左下→右上の斜線を等間隔で引く。
    for (var x = -size.height; x < size.width; x += 9) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), linePaint);
    }
  }

  @override
  bool shouldRepaint(_DiagonalStripesPainter oldDelegate) => false;
}
