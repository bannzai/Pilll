import 'package:flutter/material.dart';
import 'package:pilll/features/appstore_screenshot/mock_screens/mock_components.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

/// スクリーンショット #3（伏せた通知）の Mock。論理サイズ 430×932。
///
/// ロック画面の壁紙・時計の上に Pilll の通知バナーを重ねる。
/// バナー本文は「中身がわからない」中立的な文言にして、伏せた通知の価値を表現する。
/// 文言は [lang] で切り替える（ロック画面はアプリ外なので [L] ではなく専用文言）。
class MockLockScreen extends StatelessWidget {
  const MockLockScreen({super.key, required this.lang});

  /// 文言の言語切替に使う arb 言語コード。
  final String lang;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2B3660), Color(0xFF4C3B6E)],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 96),
          Text(
            DateTimeFormatter.yearAndMonthAndDay(DateTime(2026, 7, 18)),
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.85)),
          ),
          const SizedBox(height: 4),
          const Text('9:41', style: TextStyle(fontSize: 88, fontWeight: FontWeight.w300, color: Colors.white, height: 1.05)),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: NotificationBanner(
              message: L.notification,
              time: '9:41',
              opacity: 0.86,
            ),
          ),
          const SizedBox(height: 40),
          _bottomAffordances(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  /// ロック画面下部のフラッシュライト・カメラ相当の丸ボタン 2 つ。
  Widget _bottomAffordances() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 46),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          2,
          (_) => Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}
