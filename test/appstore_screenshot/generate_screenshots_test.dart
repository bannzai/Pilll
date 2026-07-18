import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/features/appstore_screenshot/screenshot_device.dart';
import 'package:pilll/features/appstore_screenshot/screenshot_locale.dart';
import 'package:pilll/features/appstore_screenshot/screenshot_page.dart';
import 'package:pilll/features/appstore_screenshot/screenshot_variant.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/l10n/app_localizations.dart';
import 'package:pilll/utils/environment.dart';

/// App Store スクリーンショットを widget test で撮影して PNG 出力するハーネス。
///
/// シミュレータ・実機ビルド不要。`tester.view` に 6.7" の物理サイズを設定し、
/// RepaintBoundary を toImage → PNG bytes → File 書き出しする。
///
/// 環境変数:
/// - SCREENSHOT_LANGS: カンマ区切りの arb 言語コード（未指定は全対象言語）
/// - SCREENSHOT_PAGES: カンマ区切りのページ番号で生成対象を絞り込む（未指定はバリアントの全ページ）
/// - SCREENSHOT_VARIANT: バリアント名（未指定は main）。ページの並び順を決める
///
/// バリアントごとにページの表示順が異なる（CPP 対応）。出力ファイル名の index は
/// バリアントの並び順における位置（0 始まり）にする。
///
/// フォントは scripts/generate_screenshots/fonts/ 配下の ttf/otf を全て読み込む。
/// 1 つも無ければ fetch_fonts.sh の実行を促して fail する。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const device = ScreenshotDevice.iPhone67;
  final variant =
      (Platform.environment['SCREENSHOT_VARIANT'] ?? '').trim().isEmpty
          ? 'main'
          : Platform.environment['SCREENSHOT_VARIANT']!.trim();
  final order = screenshotVariantOrder(variant: variant);
  final langs = _langsFromEnv();
  final pageFilter = _pageFilterFromEnv();

  // 読み込んだフォントのファミリー名。テーマの fontFamilyFallback に使う。
  final loadedFamilies = <String>[];

  setUpAll(() async {
    // PillMark 等の本番部品がテスト中にアニメーションを回さないようにする。
    Environment.isTest = true;
    await _loadFonts(loadedFamilies);
  });

  // 全32言語×5ページの生成は flutter test 既定の10分タイムアウトを超えるため無効化する。
  testWidgets('App Store スクリーンショットを生成する', timeout: Timeout.none,
      (tester) async {
    if (order == null) {
      fail(
          '未知のバリアントです: $variant（定義は lib/features/appstore_screenshot/screenshot_variant.dart）');
    }

    tester.view.physicalSize = Size(device.outputWidth, device.outputHeight);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // グローバル L を差し替えるので、テスト終了時に必ず元へ戻す。
    final originalL = L;
    addTearDown(() => L = originalL);

    for (final lang in langs) {
      L = lookupAppLocalizations(Locale(lang));
      for (var position = 0; position < order.length; position++) {
        final page = order[position];
        if (pageFilter != null && !pageFilter.contains(page)) {
          continue;
        }
        await _renderAndCapture(
          tester,
          lang: lang,
          page: page,
          index: position,
          variant: variant,
          device: device,
          fontFamily: _primaryFamily(lang),
          fontFamilyFallback: loadedFamilies,
        );
      }
    }
  });
}

/// SCREENSHOT_LANGS を解釈する。未指定なら全対象言語。
List<String> _langsFromEnv() {
  final value = Platform.environment['SCREENSHOT_LANGS'];
  if (value == null || value.trim().isEmpty) {
    return allScreenshotLanguages;
  }
  return value
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}

/// SCREENSHOT_PAGES を解釈する。未指定なら null（バリアントの全ページを生成）。
/// 指定時はそのページ番号だけを生成する（index はバリアント内の位置を保つ）。
Set<int>? _pageFilterFromEnv() {
  final value = Platform.environment['SCREENSHOT_PAGES'];
  if (value == null || value.trim().isEmpty) {
    return null;
  }
  return value.split(',').map((e) => int.parse(e.trim())).toSet();
}

/// 言語ごとのテーマ主フォント。CJK は Han の字形が言語で異なるため、
/// 主フォントを言語で切り替える。それ以外の言語は Latin を主フォントにし、
/// 不足する文字は [fontFamilyFallback] で補う。
String _primaryFamily(String lang) {
  switch (lang) {
    case 'ja':
      return 'NotoSansJP';
    case 'ko':
      return 'NotoSansKR';
    case 'zh':
      return 'NotoSansSC';
    default:
      return 'NotoSans';
  }
}

/// フォントディレクトリの ttf/otf を全てファミリー登録する。
///
/// ファミリー名はファイル名（拡張子除く）とし、[outFamilies] に集める。
/// 1 つも無ければ fetch_fonts.sh の実行を促して fail する。
Future<void> _loadFonts(List<String> outFamilies) async {
  final dir = Directory('scripts/generate_screenshots/fonts');
  final fontFiles = dir.existsSync()
      ? dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.ttf') || f.path.endsWith('.otf'))
          .toList()
      : <File>[];
  if (fontFiles.isEmpty) {
    fail(
        'フォントが見つかりません。先に `bash scripts/generate_screenshots/fetch_fonts.sh` を実行してください: ${dir.absolute.path}');
  }
  for (final file in fontFiles) {
    final family =
        file.uri.pathSegments.last.replaceAll(RegExp(r'\.(ttf|otf)$'), '');
    await (FontLoader(family)..addFont(_readAsByteData(file))).load();
    outFamilies.add(family);
    // 本番コンポーネントはFontFamily.japanese（"Noto Sans CJK JP"）を明示する。
    // 配布ファイル名由来のNotoSansJPだけではtest rendererがAhemへ落ちるため、
    // 同じフォントを本番のfamily名でも登録して実機に近い文字メトリクスにする。
    if (family == 'NotoSansJP') {
      await (FontLoader(FontFamily.japanese)..addFont(_readAsByteData(file)))
          .load();
      outFamilies.add(FontFamily.japanese);
    }
    if (family == 'NotoSans') {
      // flutter_testにはiOSシステムフォントのAvenir Nextが無い。未登録だとAhemの
      // 大きな行高になり、ピル番号＋マークの固定レイアウトだけがdebug overflowする。
      await (FontLoader(FontFamily.number)..addFont(_readAsByteData(file)))
          .load();
      outFamilies.add(FontFamily.number);
    }
  }
}

/// フォントファイルを FontLoader が要求する Future<ByteData> として読み込む。
Future<ByteData> _readAsByteData(File file) async {
  final bytes = await file.readAsBytes();
  return ByteData.view(Uint8List.fromList(bytes).buffer);
}

/// 1 枚を描画して PNG を artifacts へ書き出す。
Future<void> _renderAndCapture(
  WidgetTester tester, {
  required String lang,
  required int page,
  required int index,
  required String variant,
  required ScreenshotDevice device,
  required String fontFamily,
  required List<String> fontFamilyFallback,
}) async {
  final captureKey = GlobalKey();
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale(lang),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
      ),
      home: Material(
        color: Colors.transparent,
        child: Center(
          child: RepaintBoundary(
            key: captureKey,
            child: MediaQuery(
              // Simulator正式経路では外側のFittedBox内でも端末の論理サイズ430×932が
              // MediaQueryに入る。widget testも同じ条件にし、PageViewのviewportFractionを
              // 1290px出力幅から誤計算しないようにする。
              data: MediaQueryData(
                  size: Size(device.logicalWidth, device.logicalHeight),
                  devicePixelRatio: 3),
              child: screenshotPage(lang: lang, page: page, device: device),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  // PNG エンコードは実 async が必要なため runAsync 内で行う。
  await tester.runAsync(() async {
    final boundary =
        captureKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 1.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    if (byteData == null) {
      fail('画像のエンコードに失敗しました: lang=$lang page=$page');
    }
    final outputFile = File(_outputPath(
        variant: variant, lang: lang, index: index, device: device));
    await outputFile.create(recursive: true);
    await outputFile.writeAsBytes(byteData.buffer.asUint8List());
    // ignore: avoid_print
    print('generated: ${outputFile.path}');
  });
}

/// 出力先パス。
///
/// scripts/generate_screenshots/artifacts/_variant-{variant}/{fastlaneLocale}/{idx}_{label}_{idx}.png
/// idx はバリアントの並び順における位置（0 始まり）。deliver は画像のピクセル寸法で
/// デバイス種別を判定するため、ファイル名のラベルは可読性のためだけに使う。
String _outputPath({
  required String variant,
  required String lang,
  required int index,
  required ScreenshotDevice device,
}) {
  return 'scripts/generate_screenshots/artifacts/_variant-$variant/${fastlaneLocaleOf(lang: lang)}/${index}_${device.fastlaneLabel}_$index.png';
}
