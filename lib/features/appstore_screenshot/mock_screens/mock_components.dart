import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/localizations/l.dart';

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

/// 本番のホーム画面（home/page.dart）に合わせた 4 タブのボトムバー。
///
/// 記録（ピル）・生理・カレンダー・設定。ラベルは [L] で国際化し、選択中のタブは
/// AppColors.primary（本番の TabBar.labelColor）で示す。アイコンは自前描画。
class MockBottomTabBar extends StatelessWidget {
  const MockBottomTabBar({super.key, required this.activeIndex});

  /// 選択中タブのインデックス（0:記録 1:生理 2:カレンダー 3:設定）。
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bottomBar,
        border: Border(top: BorderSide(width: 1, color: AppColors.border)),
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tab(index: 0, icon: _pillIcon, label: L.pill),
          _tab(index: 1, icon: _periodIcon, label: L.menstruation),
          _tab(index: 2, icon: _calendarIcon, label: L.calendar),
          _tab(index: 3, icon: _gearIcon, label: L.settings),
        ],
      ),
    );
  }

  /// 1 タブ（アイコン＋ラベル）を組む。
  Widget _tab({required int index, required Widget Function(Color) icon, required String label}) {
    final color = index == activeIndex ? AppColors.primary : TextColor.gray;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 26, height: 26, child: Center(child: icon(color))),
        const SizedBox(height: 3),
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: color)),
      ],
    );
  }

  Widget _pillIcon(Color color) => PillCapsule(width: 24, height: 12, color: color);

  Widget _periodIcon(Color color) => CustomPaint(size: const Size(20, 24), painter: TeardropPainter(color: color));

  Widget _calendarIcon(Color color) => Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(border: Border.all(color: color, width: 2), borderRadius: BorderRadius.circular(4)),
        child: Column(children: [Container(height: 5, color: color)]),
      );

  Widget _gearIcon(Color color) => CustomPaint(size: const Size(24, 24), painter: GearPainter(color: color));
}

/// しずく（生理タブのアイコン代替）を描く。
class TeardropPainter extends CustomPainter {
  const TeardropPainter({required this.color});

  /// しずくの塗り色。
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.5, 0)
        ..cubicTo(size.width * 0.95, size.height * 0.5, size.width * 0.85, size.height, size.width * 0.5, size.height)
        ..cubicTo(size.width * 0.15, size.height, size.width * 0.05, size.height * 0.5, size.width * 0.5, 0)
        ..close(),
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(TeardropPainter oldDelegate) => oldDelegate.color != color;
}

/// 歯車（設定タブのアイコン代替）を描く。
class GearPainter extends CustomPainter {
  const GearPainter({required this.color});

  /// 歯車の色。
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    // 8 枚の歯を放射状に描く。
    for (var i = 0; i < 8; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(3.1415926 * i / 4);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(-size.width * 0.09, -size.height * 0.5, size.width * 0.18, size.height * 0.22), const Radius.circular(1.5)),
        paint,
      );
      canvas.restore();
    }
    canvas.drawCircle(center, size.width * 0.30, paint);
    canvas.drawCircle(center, size.width * 0.13, Paint()..color = AppColors.bottomBar);
  }

  @override
  bool shouldRepaint(GearPainter oldDelegate) => oldDelegate.color != color;
}

/// 送りチェブロン（服用済みマークの間の「▶」）を描く。
class ChevronPainter extends CustomPainter {
  const ChevronPainter({required this.color});

  /// チェブロンの色。
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.2, size.height * 0.15)
        ..lineTo(size.width * 0.75, size.height * 0.5)
        ..lineTo(size.width * 0.2, size.height * 0.85),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(ChevronPainter oldDelegate) => oldDelegate.color != color;
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
