import 'package:flutter/material.dart';

/// コード描画の iPhone フレーム。画像アセットを使わずに角丸筐体・
/// ベゼル・Dynamic Island・影を描く。
///
/// [child] はフレーム内側（画面表示領域）の実寸に一致するサイズで渡す。
/// 各寸法は [frameWidth] に対する比率で算出し、他デバイスへ流用できるようにする。
class DeviceFrameOverlay extends StatelessWidget {
  const DeviceFrameOverlay({
    super.key,
    required this.frameWidth,
    required this.frameHeight,
    required this.bezel,
    required this.child,
  });

  /// フレーム外形の幅。
  final double frameWidth;

  /// フレーム外形の高さ。
  final double frameHeight;

  /// ベゼル幅（フレーム内側の余白）。
  final double bezel;

  /// フレーム内側に表示する画面 Widget。フレーム内側の実寸で渡す。
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // iPhone 実機の比率に近づけた角丸・Dynamic Island の寸法（フレーム幅基準）。
    final outerRadius = frameWidth * 0.135;
    final innerRadius = outerRadius - bezel * 0.6;
    final islandWidth = frameWidth * 0.30;
    final islandHeight = frameWidth * 0.085;

    return Container(
      width: frameWidth,
      height: frameHeight,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1C),
        borderRadius: BorderRadius.circular(outerRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: frameWidth * 0.06,
            offset: Offset(0, frameWidth * 0.02),
          ),
        ],
      ),
      padding: EdgeInsets.all(bezel),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(innerRadius),
            child: child,
          ),
          // Dynamic Island（黒カプセル）を画面上部中央に重ねる。
          Positioned(
            top: frameHeight * 0.014,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: islandWidth,
                height: islandHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0A0A),
                  borderRadius: BorderRadius.circular(islandHeight / 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
