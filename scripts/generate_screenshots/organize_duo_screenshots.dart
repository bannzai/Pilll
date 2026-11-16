import 'dart:io';

import 'package:pilll/features/appstore_screenshot/screenshot_locale.dart';
import 'package:pilll/features/appstore_screenshot/screenshot_variant.dart';

/// iPhone Duo Simulator で撮影した「姿勢 × 言語 × ページ」のスクリーンショットを、
/// App Store Connect のロケール（screenshot_locale.dart が SSOT）ごとに展開する。
///
/// 入力: scripts/generate_screenshots/artifacts/iphone-duo/_captured/{outer|inner}/{arbコード}/p{N}.png
/// 出力: scripts/generate_screenshots/artifacts/iphone-duo/{ASCロケール}/{idx}_APP_IPHONE_DUO_{OUTER|INNER}_p{N}.png
///
/// 並び順は通常配信（main バリアント）のページ順で、idx はその位置（0 始まり）。
/// iPhone Duo の枠は外側・内側を合わせて 1 つ（最大 10 枚）のため、CPP バリアントは展開しない。
/// 出力先は deliver が読む fastlane/screenshots/ ではなく、organize_screenshots.dart が消す
/// _variant-* とも別にして、既存の iPhone / iPad の配信に混ざらないようにする。
/// 実行: dart run scripts/generate_screenshots/organize_duo_screenshots.dart
void main() {
  final capturedRoot = Directory('scripts/generate_screenshots/artifacts/iphone-duo/_captured');
  if (!capturedRoot.existsSync()) {
    stderr.writeln('iPhone Duo の撮影結果が見つかりません: ${capturedRoot.path}');
    stderr.writeln('先に capture_duo_screenshots.sh で撮影してください。');
    exit(1);
  }

  final order = screenshotVariants['main']!;
  var copied = 0;
  var missing = 0;
  for (final storeLocale in allStoreScreenshotLocales) {
    final lang = screenshotLanguageOf(locale: storeLocale);
    final localeDir = Directory('scripts/generate_screenshots/artifacts/iphone-duo/$storeLocale');
    if (localeDir.existsSync()) {
      localeDir.deleteSync(recursive: true);
    }
    for (final side in const ['outer', 'inner']) {
      for (var position = 0; position < order.length; position++) {
        final source = File('${capturedRoot.path}/$side/$lang/p${order[position]}.png');
        if (!source.existsSync()) {
          stderr.writeln('欠落: ${source.path}');
          missing++;
          continue;
        }
        final destination = File('${localeDir.path}/${position}_APP_IPHONE_DUO_${side.toUpperCase()}_p${order[position]}.png');
        destination.parent.createSync(recursive: true);
        source.copySync(destination.path);
        copied++;
      }
    }
  }

  stdout.writeln('配置完了: $copied 枚を ${allStoreScreenshotLocales.length} ロケールへ展開しました（欠落 $missing）。');
  if (missing > 0) {
    exit(1);
  }
}
