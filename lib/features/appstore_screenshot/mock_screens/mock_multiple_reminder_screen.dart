import 'package:flutter/material.dart';
import 'package:pilll/features/appstore_screenshot/mock_screens/mock_components.dart';
import 'package:pilll/features/localizations/l.dart';

/// スクリーンショット #4（複数回リマインド）の Mock。論理サイズ 430×932。
///
/// 服用通知が時刻を変えて何度も届く様子を、積み重なった通知バナーで表現する。
/// 最新（最前面）のバナーは服用済みの確認にして「気づいて飲めた」までを1枚で見せる。
/// 通知本文は [L] の既存文言、時刻表記は [lang] で切り替える。
class MockMultipleReminderScreen extends StatelessWidget {
  const MockMultipleReminderScreen({super.key, required this.lang});

  /// 時刻表記の言語切替に使う arb 言語コード。
  final String lang;

  /// 言語ごとの最新通知の相対時刻表記。未定義言語は en にフォールバック。
  static const Map<String, String> _nowLabel = {'ja': '今', 'en': 'now'};

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4C6488), Color(0xFF32476B)],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 108),
          Text('9:41', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.9))),
          const Spacer(),
          // 古い通知ほど上に薄く小さく積む。最新は最前面（下）で服用済み確認。
          _reminderBanner(time: '8:00', opacity: 0.55, scale: 0.92),
          const SizedBox(height: 12),
          _reminderBanner(time: '12:30', opacity: 0.78, scale: 0.96),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: NotificationBanner(
              message: _stripEmoji(L.taken),
              time: _nowLabel[lang] ?? _nowLabel['en']!,
              showCheck: true,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  /// 服用を促すリマインダーのバナー 1 枚。古いものは薄く小さく見せる。
  Widget _reminderBanner({required String time, required double opacity, required double scale}) {
    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: NotificationBanner(message: L.takePillReminder, time: time),
        ),
      ),
    );
  }

  /// 先頭の絵文字を取り除く（服用済み文言に絵文字が含まれる場合の保険）。
  static String _stripEmoji(String text) {
    return text.replaceAll(RegExp(r'[\u{1F000}-\u{1FAFF}\u{2600}-\u{27BF}\u{FE0F}\u{2190}-\u{21FF}]', unicode: true), '').trim();
  }
}
