import 'dart:math' as math;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/appstore_screenshot/mock_screens/mock_components.dart';
import 'package:pilll/features/appstore_screenshot/mock_screens/mock_record_screen.dart';

/// スクリーンショット #1（社会的証明＋中核価値）の Mock。論理サイズ 430×932。
///
/// 実機ストア 1 枚目（tmp/research/screenshots/pilll/jp/01.png）に倣い、記録ページ
/// （[MockRecordScreen]）を土台に、Pilll の服用通知バナーと「利用者数14万人突破」の
/// スカラップバッジを重ねる。中核 UI を見せながら社会的証明を1枚で伝える。
/// 文言は [lang] で切り替える（実機の通知本文・バッジは日本語固有表現のため）。
class MockSocialProofScreen extends StatelessWidget {
  const MockSocialProofScreen({super.key, required this.lang});

  /// バッジ・通知文言の言語切替に使う arb 言語コード。
  final String lang;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MockRecordScreen(lang: lang),
        // ピルシートの上に届く服用通知バナー。
        Positioned(
          top: 168,
          left: 16,
          right: 44,
          child: NotificationBanner(
            message: reminderNotificationSampleBody(),
            time: '9:41',
          ),
        ),
        // 右下に浮かせる「利用者数14万人突破」バッジ（ステッカー風に傾ける）。
        Positioned(
          right: 12,
          bottom: 204,
          child: Transform.rotate(angle: -0.1, child: _badge(size: 148)),
        ),
      ],
    );
  }

  /// スカラップ（花形）の社会的証明バッジ。
  Widget _badge({required double size}) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(size: Size(size, size), painter: const _ScallopPainter()),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                NumberFormat.compact(locale: Platform.localeName).format(140000),
                style: TextStyle(fontSize: size * 0.25, fontWeight: FontWeight.w900, color: TextColor.primaryDarkBlue),
              ),
              const SizedBox(height: 1),
              Text('★4.7', style: TextStyle(fontSize: size * 0.16, fontWeight: FontWeight.w800, color: TextColor.primaryDarkBlue)),
            ],
          ),
        ],
      ),
    );
  }
}

/// スカラップ（外周が丸い花びら状）のバッジを描く。
class _ScallopPainter extends CustomPainter {
  const _ScallopPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final baseRadius = size.width * 0.40;
    final bumpRadius = size.width * 0.075;
    // 影を落として画面の上に浮くステッカー感を出す。
    canvas.drawShadow(Path()..addOval(Rect.fromCircle(center: center, radius: baseRadius)), Colors.black.withValues(alpha: 0.35), 6, false);
    // 外周に沿って小円を並べて花びら状の縁を作る。
    const bumps = 16;
    final bumpPaint = Paint()
      ..color = const Color(0xFFF3C33F)
      ..style = PaintingStyle.fill;
    for (var i = 0; i < bumps; i++) {
      final angle = 2 * math.pi * i / bumps;
      canvas.drawCircle(center + Offset(math.cos(angle) * baseRadius, math.sin(angle) * baseRadius), bumpRadius, bumpPaint);
    }
    canvas.drawCircle(center, baseRadius, Paint()..color = const Color(0xFFF3C33F));
    canvas.drawCircle(center, baseRadius * 0.9, Paint()..color = const Color(0xFFFAD65E));
  }

  @override
  bool shouldRepaint(_ScallopPainter oldDelegate) => false;
}
