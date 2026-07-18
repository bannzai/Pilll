import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';

/// スクリーンショット用 Mock 画面で共有する部品と描画ヘルパー。
///
/// アイコン類は Material Icons を使わない。flutter test 環境では MaterialIcons
/// フォントが解決されず豆腐になるため、記号は自前描画する。

/// Pilll のアプリアイコンを模した角丸スクエア。
/// コーラル地に白のピルカプセルを重ねる。
class PilllAppIcon extends StatelessWidget {
  const PilllAppIcon({super.key, required this.size});

  /// アイコンの一辺の長さ。
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF08A5D), AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(size * 0.24),
      ),
      child: Center(
        child: PillCapsule(width: size * 0.5, height: size * 0.24, color: Colors.white),
      ),
    );
  }
}

/// ピル錠を模した傾いたカプセル。アプリアイコンやタブアイコンに使う。
class PillCapsule extends StatelessWidget {
  const PillCapsule({super.key, required this.width, required this.height, required this.color});

  /// カプセルの長辺。
  final double width;

  /// カプセルの短辺。
  final double height;

  /// カプセルの色。
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.7,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(height / 2)),
      ),
    );
  }
}

/// iOS の通知バナーを模したカード。
///
/// アプリアイコン・アプリ名・時刻・本文を並べる。ロック画面・ホーム画面いずれでも使う。
/// 実機の iOS 通知に合わせ、アプリ名は 1 行だけ（上段）、その下に本文を置く。
class NotificationBanner extends StatelessWidget {
  const NotificationBanner({
    super.key,
    required this.message,
    required this.time,
    this.opacity = 0.96,
    this.showCheck = false,
  });

  /// アプリ名の下に太字で出す本文。
  final String message;

  /// 右上に出す時刻表記（"今" / "9:41" 等）。
  final String time;

  /// カード背景の不透明度。ロック画面では磨りガラス風に下げる。
  final double opacity;

  /// 右端に緑のチェック丸を出すか。服用済みの確認バナーに使う。
  final bool showCheck;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const PilllAppIcon(size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Pilll', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: TextColor.gray)),
                    const Spacer(),
                    Text(time, style: const TextStyle(fontSize: 12, color: TextColor.gray)),
                  ],
                ),
                const SizedBox(height: 3),
                Text(message, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: TextColor.main)),
              ],
            ),
          ),
          if (showCheck) ...[
            const SizedBox(width: 12),
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
              child: const Center(child: CustomPaint(size: Size(14, 11), painter: CheckPainter(color: Colors.white, strokeWidth: 2.2))),
            ),
          ],
        ],
      ),
    );
  }
}

/// チェックマーク（レ点）を描く。服用済みマーク・完了表示に使う。
class CheckPainter extends CustomPainter {
  const CheckPainter({required this.color, this.strokeWidth = 1.8});

  /// レ点の色。
  final Color color;

  /// レ点の線幅。
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.1, size.height * 0.55)
        ..lineTo(size.width * 0.4, size.height * 0.9)
        ..lineTo(size.width * 0.95, size.height * 0.1),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(CheckPainter oldDelegate) => oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

/// ハートを描く。生理・お気に入りの表現に使う。
class HeartPainter extends CustomPainter {
  const HeartPainter({required this.color});

  /// ハートの塗り色。
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.5, size.height * 0.95)
        ..cubicTo(size.width * -0.15, size.height * 0.5, size.width * 0.2, size.height * 0.0, size.width * 0.5, size.height * 0.32)
        ..cubicTo(size.width * 1.15, size.height * 0.0, size.width * 0.8, size.height * 0.5, size.width * 0.5, size.height * 0.95)
        ..close(),
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(HeartPainter oldDelegate) => oldDelegate.color != color;
}
