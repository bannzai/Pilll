import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/appstore_screenshot/mock_screens/mock_components.dart';
import 'package:pilll/features/localizations/l.dart';

/// スクリーンショット #5（生理管理）の Mock。論理サイズ 430×932。
///
/// 週カレンダーと「生理予定日まであと N 日」カードで、ピルと生理を一緒に管理できる
/// 価値を表現する。ピンクを差し色にする。
/// 見出し・日数は [L] の既存文言、曜日・月ラベルは [lang] で切り替える。
class MockMenstruationScreen extends StatelessWidget {
  const MockMenstruationScreen({super.key, required this.lang});

  /// 曜日・月ラベルの言語切替に使う arb 言語コード。
  final String lang;

  /// 今日から生理予定日までの残り日数。
  static const int _remainingDays = 5;

  /// 週カレンダーに表示する日付（日曜始まりの 1 週間）。
  static const List<int> _dates = [12, 13, 14, 15, 16, 17, 18];

  /// 今日の日付。
  static const int _today = 12;

  /// 生理予定日。
  static const int _scheduledDate = 17;

  /// 言語ごとの曜日短縮ラベル（日曜始まり）。未定義言語は en にフォールバック。
  static const Map<String, List<String>> _weekdayLabels = {
    'ja': ['日', '月', '火', '水', '木', '金', '土'],
    'en': ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
  };

  /// 言語ごとの月ラベル。
  static const Map<String, String> _monthLabel = {'ja': '1月', 'en': 'January'};

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          _statusBar(),
          _appBar(),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_monthLabel[lang] ?? _monthLabel['en']!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: TextColor.main)),
                const SizedBox(height: 16),
                _weekCalendar(),
                const SizedBox(height: 28),
                _scheduleCard(),
              ],
            ),
          ),
          const Spacer(),
          _bottomNavigationBar(),
        ],
      ),
    );
  }

  /// iOS のステータスバー相当。
  Widget _statusBar() {
    return const SizedBox(
      height: 59,
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

  /// 画面上部のアプリバー。
  Widget _appBar() {
    return Container(
      height: 52,
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Row(
        children: [
          Text('Pilll', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: TextColor.primaryDarkBlue)),
        ],
      ),
    );
  }

  /// 1 週間分の週カレンダー。生理予定日をピンクで塗り、今日を枠で示す。
  Widget _weekCalendar() {
    final labels = _weekdayLabels[lang] ?? _weekdayLabels['en']!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < 7; i++)
          Column(
            children: [
              Text(
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
              const SizedBox(height: 8),
              _dateCircle(_dates[i]),
            ],
          ),
      ],
    );
  }

  /// 日付の丸。生理予定日はピンク塗り、今日は枠線、それ以外は素の数字。
  Widget _dateCircle(int date) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: date == _scheduledDate ? AppColors.menstruation : Colors.transparent,
        shape: BoxShape.circle,
        border: date == _today ? Border.all(color: AppColors.secondary, width: 2) : null,
      ),
      child: Center(
        child: Text(
          '$date',
          style: TextStyle(
            fontSize: 15,
            fontWeight: date == _today || date == _scheduledDate ? FontWeight.w700 : FontWeight.w500,
            color: date == _scheduledDate ? Colors.white : TextColor.main,
          ),
        ),
      ),
    );
  }

  /// 「生理予定日 / あと N 日」カード。ピンクの差し色。
  Widget _scheduleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.menstruation.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.menstruation, width: 1.5),
      ),
      child: Row(
        children: [
          const CustomPaint(size: Size(34, 31), painter: HeartPainter(color: AppColors.menstruation)),
          const SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(L.menstruationScheduleDate, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: TextColor.lightGray2)),
              const SizedBox(height: 4),
              Text(
                L.menstruationRemainingDay(_remainingDays),
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Color(0xFFC9788A)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 画面下部のタブバー。生理タブ（ハート）を選択状態にする。
  Widget _bottomNavigationBar() {
    return Container(
      height: 84,
      decoration: const BoxDecoration(color: AppColors.bottomBar, border: Border(top: BorderSide(color: AppColors.border))),
      padding: const EdgeInsets.only(top: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PillCapsule(width: 28, height: 13, color: AppColors.gray),
          _calendarTab(),
          const CustomPaint(size: Size(26, 24), painter: HeartPainter(color: AppColors.secondary)),
        ],
      ),
    );
  }

  /// カレンダータブ。
  Widget _calendarTab() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(border: Border.all(color: AppColors.gray, width: 2), borderRadius: BorderRadius.circular(4)),
      child: Column(children: [Container(height: 6, color: AppColors.gray)]),
    );
  }
}
