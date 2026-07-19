import 'package:flutter/material.dart';
import 'package:pilll/features/appstore_screenshot/device_frame_overlay.dart';
import 'package:pilll/features/appstore_screenshot/screenshot_background.dart';
import 'package:pilll/features/appstore_screenshot/screenshot_device.dart';

/// App Store スクリーンショット 1 枚のレイアウトを組む共通コンテナ。
///
/// レイヤ構造は次の通り:
/// 1. 背景 LinearGradient（2色）
/// 2. 上部にタイトル（太字・白・一部単語のみアクセント色）とサブタイトル
/// 3. コード描画の iPhone フレーム
/// 4. フレーム内に論理サイズの [child] を実寸へ拡大して配置
///
/// [child] は [device] の logicalWidth × logicalHeight ちょうどのサイズで渡す。
class AppStoreScreenshotFrameLayout extends StatelessWidget {
  const AppStoreScreenshotFrameLayout({
    super.key,
    required this.device,
    required this.background,
    required this.title,
    required this.subtitle,
    required this.titleAccentWord,
    required this.child,
  });

  /// 出力寸法・レイアウト比率を持つデバイス定義。
  final ScreenshotDevice device;

  /// 背景グラデーション。
  final ScreenshotBackground background;

  /// タイトル文言。
  final String title;

  /// サブタイトル文言。
  final String subtitle;

  /// タイトル内でアクセント色にする単語（[title] に含まれる場合のみ着色）。
  final String? titleAccentWord;

  /// フレーム内に表示する Mock 画面。論理サイズで渡す。
  final Widget child;

  /// アクセント語に使う暖色のクリーム色。濃い背景色上で読める明度にしている。
  static const Color _accentColor = Color(0xFFFFDCA3);

  /// コピー文字列のスクリプトから文字方向を判定する。
  /// RTL スクリプト（ヘブライ・アラビア・シリア文字と各種表示形）を含めば RTL、無ければ LTR。
  static TextDirection _copyTextDirection(String text) {
    return RegExp('[֐-׿؀-ۿ܀-ݏݐ-ݿࢠ-ࣿיִ-ﭏﭐ-﷿ﹰ-﻿]').hasMatch(text) ? TextDirection.rtl : TextDirection.ltr;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: device.outputWidth,
      height: device.outputHeight,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: background.gradient),
            ),
          ),
          // キャッチコピー帯。帯の中で上下中央に寄せる。
          // 文字方向はコピー自身のスクリプトに従う（UI ロケールの RTL を継承しない）。
          // これにより、RTL ロケールで英語へフォールバックした場合も句読点が乱れない。
          Positioned(
            top: device.textBandTop,
            left: device.textSidePadding,
            right: device.textSidePadding,
            height: device.textBandHeight,
            child: Directionality(
              textDirection: _copyTextDirection('$title$subtitle'),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // タイトルは明示改行（\n）だけで折り返し、幅を超える行は
                    // 語中で折り返さず縮小して収める（scaleDown は拡大しない）。
                    FittedBox(fit: BoxFit.scaleDown, child: _title()),
                    SizedBox(height: device.titleSubtitleGap),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: device.subtitleFontSize,
                        fontWeight: FontWeight.w500,
                        height: 1.32,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // iPhone フレーム。論理サイズの child を実寸へ拡大して収める。
          Positioned(
            top: device.frameTop,
            left: device.frameLeft,
            child: DeviceFrameOverlay(
              frameWidth: device.frameWidth,
              frameHeight: device.frameHeight,
              bezel: device.frameBezel,
              child: SizedBox(
                width: device.innerScreenWidth,
                height: device.innerScreenHeight,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: SizedBox(
                    width: device.logicalWidth,
                    height: device.logicalHeight,
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// タイトルを描く。[titleAccentWord] が [title] に含まれる場合、その語だけ
  /// アクセント色にした Text.rich を返す。含まれない場合は全体を白で描く。
  Widget _title() {
    final baseStyle = TextStyle(
      color: Colors.white,
      fontSize: device.titleFontSize,
      fontWeight: FontWeight.w800,
      height: 1.12,
    );
    final accentWord = titleAccentWord;
    if (accentWord == null || !title.contains(accentWord)) {
      return Text(title, textAlign: TextAlign.center, softWrap: false, style: baseStyle);
    }
    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: title
            .split(accentWord)
            .expand((segment) => [
                  TextSpan(text: segment),
                  TextSpan(text: accentWord, style: const TextStyle(color: _accentColor)),
                ])
            .toList()
          // split の結果は要素数が区切り数+1。最後に余分なアクセント語が付くため取り除く。
          ..removeLast(),
      ),
      textAlign: TextAlign.center,
      softWrap: false,
    );
  }
}
