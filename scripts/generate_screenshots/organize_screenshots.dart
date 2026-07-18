import 'dart:io';

import 'package:pilll/features/appstore_screenshot/screenshot_locale.dart';
import 'package:pilll/features/appstore_screenshot/screenshot_variant.dart';

/// Simulator で撮影した「言語 × ページ」のスクリーンショットを、
/// バリアントの並び順（screenshot_variant.dart が SSOT）に従って
/// _variant-{variant}/{fastlaneロケール}/{idx}_APP_IPHONE_67_{idx}.png へ並べ替え配置する。
///
/// 入力: scripts/generate_screenshots/artifacts/simulator/{arbコード}/p{N}.png
/// 出力: scripts/generate_screenshots/artifacts/_variant-{variant}/{fastlaneロケール}/...
///
/// CPP バリアントは同じ 5 枚の並び替えなので撮影は 1 回で済み、ここでファイル並びとして表現する。
/// 実行: dart run scripts/generate_screenshots/organize_screenshots.dart
void main() {
  final simRoot = Directory('scripts/generate_screenshots/artifacts/simulator');
  if (!simRoot.existsSync()) {
    stderr.writeln('Simulator 撮影結果が見つかりません: ${simRoot.path}');
    stderr.writeln('先に capture_screenshots.sh で撮影してください。');
    exit(1);
  }

  var copied = 0;
  var missing = 0;
  for (final entry in screenshotVariants.entries) {
    final variant = entry.key;
    final order = entry.value;
    final variantRoot = Directory('scripts/generate_screenshots/artifacts/_variant-$variant');
    if (variantRoot.existsSync()) {
      variantRoot.deleteSync(recursive: true);
    }
    final locales = variant == 'main'
        ? allStoreScreenshotLocales
        : variant == 'cpp-birthcontrol'
            ? const ['en-US']
            : allCppScreenshotLocales;
    for (final fastlaneLocale in locales) {
      final lang = screenshotLanguageOf(locale: fastlaneLocale);
      final langDir = Directory('${simRoot.path}/$lang');
      for (var position = 0; position < order.length; position++) {
        final source = File('${langDir.path}/p${order[position]}.png');
        if (!source.existsSync()) {
          stderr.writeln('欠落: ${source.path}');
          missing++;
          continue;
        }
        final destination = File(
          'scripts/generate_screenshots/artifacts/_variant-$variant/$fastlaneLocale/${position}_APP_IPHONE_67_$position.png',
        );
        destination.parent.createSync(recursive: true);
        source.copySync(destination.path);
        copied++;
      }
    }
  }

  stdout.writeln('配置完了: $copied 枚を ${screenshotVariants.length} バリアントへ並べ替えました（欠落 $missing）。');
  if (missing > 0) {
    exit(1);
  }
}
