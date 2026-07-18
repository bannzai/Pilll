import 'package:flutter/material.dart';
import 'package:pilll/features/appstore_screenshot/mock_screens/mock_components.dart';

/// スクリーンショット #3（伏せた通知）の Mock。論理サイズ 430×932。
///
/// ロック画面の壁紙・時計の上に Pilll の通知バナーを重ねる。
/// バナー本文は「中身がわからない」中立的な文言にして、伏せた通知の価値を表現する。
/// 文言は [lang] で切り替える（ロック画面はアプリ外なので [L] ではなく専用文言）。
class MockLockScreen extends StatelessWidget {
  const MockLockScreen({super.key, required this.lang});

  /// 文言の言語切替に使う arb 言語コード。
  final String lang;

  /// 言語ごとの日付表記（固定の見本日）。未定義言語は en にフォールバック。
  static const Map<String, String> _dateLabel = {'ja': '1月12日 金曜日', 'en': 'Friday, January 12'};

  /// 言語ごとの、中身を明かさない中立的な通知本文。
  static const Map<String, String> _discreetBody = {'ja': 'リマインダーがあります', 'en': 'You have a reminder'};

  /// 言語ごとの通知時刻表記。
  static const Map<String, String> _agoLabel = {'ja': '1分前', 'en': '1m ago'};

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
            _dateLabel[lang] ?? _dateLabel['en']!,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.85)),
          ),
          const SizedBox(height: 4),
          const Text('9:41', style: TextStyle(fontSize: 88, fontWeight: FontWeight.w300, color: Colors.white, height: 1.05)),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: NotificationBanner(
              message: _discreetBody[lang] ?? _discreetBody['en']!,
              time: _agoLabel[lang] ?? _agoLabel['en']!,
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
