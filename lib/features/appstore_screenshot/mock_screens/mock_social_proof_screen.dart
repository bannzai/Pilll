import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/appstore_screenshot/mock_screens/mock_components.dart';
import 'package:pilll/features/appstore_screenshot/mock_screens/mock_record_screen.dart';
import 'package:pilll/features/localizations/l.dart';

/// スクリーンショット #1（社会的証明＋中核価値）の Mock。論理サイズ 430×932。
///
/// ピルシート画面（[MockRecordScreen]）を土台に、Pilll の服用通知バナーと
/// 「14万人が利用中」のサンバーストバッジを重ねる。中核 UI を見せながら
/// 「多くの人に使われている飲み忘れ防止アプリ」を1枚で伝える（ストア1枚目の定石）。
/// 通知本文は [L] の既存文言、バッジ文言は [lang] で切り替える。
class MockSocialProofScreen extends StatelessWidget {
  const MockSocialProofScreen({super.key, required this.lang});

  /// バッジ文言・時刻表記の言語切替に使う arb 言語コード。
  final String lang;

  /// 言語ごとのバッジ大見出し（利用者数）。未定義言語は en にフォールバック。
  static const Map<String, String> _badgeNumber = {'ja': '14万', 'en': '140K+'};

  /// 言語ごとのバッジ小見出し（単位）。
  static const Map<String, String> _badgeLabel = {'ja': '人が利用中', 'en': 'users'};

  /// 言語ごとの通知時刻表記。
  static const Map<String, String> _nowLabel = {'ja': '今', 'en': 'now'};

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MockRecordScreen(lang: lang),
        // 上部に届く服用通知バナー。
        Positioned(
          top: 74,
          left: 16,
          right: 16,
          child: NotificationBanner(message: L.takePillReminder, time: _nowLabel[lang] ?? _nowLabel['en']!),
        ),
        // 下部の空きに浮かせる「14万人が利用中」バッジ（ステッカー風に傾ける）。
        Positioned(
          right: 20,
          bottom: 150,
          child: Transform.rotate(angle: -0.12, child: _badge(size: 178)),
        ),
      ],
    );
  }

  /// 「14万人が利用中」のサンバーストバッジ。
  Widget _badge({required double size}) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(size: Size(size, size), painter: const _SunburstPainter()),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _badgeNumber[lang] ?? _badgeNumber['en']!,
                style: TextStyle(fontSize: size * 0.24, fontWeight: FontWeight.w900, color: TextColor.primaryDarkBlue, height: 1.0),
              ),
              const SizedBox(height: 2),
              Text(
                _badgeLabel[lang] ?? _badgeLabel['en']!,
                style: TextStyle(fontSize: size * 0.1, fontWeight: FontWeight.w700, color: TextColor.primaryDarkBlue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 黄色系サンバースト（多数の光条を持つ星型バッジ）を描く。
class _SunburstPainter extends CustomPainter {
  const _SunburstPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    // 光条の数。多すぎず賑やかに見える 20 本にする。
    const points = 20;
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * 0.86;
    final path = Path();
    for (var i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = math.pi * i / points - math.pi / 2;
      final point = center + Offset(math.cos(angle) * radius, math.sin(angle) * radius);
      i == 0 ? path.moveTo(point.dx, point.dy) : path.lineTo(point.dx, point.dy);
    }
    path.close();
    // 影を落としてアプリ画面の上に浮くステッカー感を出す。
    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.4), 6, false);
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFF6C544)
        ..style = PaintingStyle.fill,
    );
    // 内側の円で落ち着いた面を作り、文字を読みやすくする。
    canvas.drawCircle(
      center,
      innerRadius * 0.9,
      Paint()
        ..color = const Color(0xFFFFD86B)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_SunburstPainter oldDelegate) => false;
}
