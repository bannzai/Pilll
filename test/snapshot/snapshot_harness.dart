import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/app.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/l10n/app_localizations.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/environment.dart';

import '../helper/fake.dart';
import '../helper/mock.mocks.dart';

/// snapshot テストで撮る言語 (arb の言語コード)。
const snapshotLanguages = ['ja', 'en'];

/// snapshot テストの「今日」。日付で表示が変わる画面 (記録・カレンダー・生理) の基準画像を日によって変えないため固定する。
final snapshotToday = DateTime(2026, 10, 15);

/// snapshot テストの画面の論理サイズ (iPhone 13 / 14 相当)。
const snapshotLogicalSize = Size(390, 844);

/// フォントを置くディレクトリ。CI では scripts/snapshot_testing/fetch_fonts.sh が取得する (gitignore 対象)。
const snapshotFontDirectory = 'test/snapshot/fonts';

/// テストの環境 (日付・analytics・フォント) を整える。setUpAll から 1 回だけ呼ぶ。
///
/// フォントが無いと文字が Ahem (豆腐) になり、文言・翻訳の違いを画像で比べられないため、無ければ fail する。
Future<void> setUpSnapshotEnvironment() async {
  Environment.isTest = true;
  analytics = FakeAnalytics();
  final todayService = MockTodayService();
  when(todayService.now()).thenReturn(snapshotToday);
  todayRepository = todayService;
  for (final lang in snapshotLanguages) {
    await initializeDateFormatting(lang);
  }
  await _loadBundledFonts();
  await _loadDownloadedFonts();
}

/// pubspec と SDK が同梱するフォント (Material Icons 等) を FontManifest.json から読み込む。
Future<void> _loadBundledFonts() async {
  for (final entry in (json.decode(await rootBundle.loadString('FontManifest.json')) as List<dynamic>).cast<Map<String, dynamic>>()) {
    final loader = FontLoader(entry['family'] as String);
    for (final font in (entry['fonts'] as List<dynamic>).cast<Map<String, dynamic>>()) {
      loader.addFont(rootBundle.load(font['asset'] as String));
    }
    await loader.load();
  }
}

/// [snapshotFontDirectory] の Noto フォントを、本番のコンポーネントが指定するファミリー名でも登録する。
Future<void> _loadDownloadedFonts() async {
  final files = {
    'NotoSans': File('$snapshotFontDirectory/NotoSans.ttf'),
    'NotoSansJP': File('$snapshotFontDirectory/NotoSansJP.ttf'),
    'NotoEmoji': File('$snapshotFontDirectory/NotoEmoji.ttf'),
  };
  final missing = files.values.where((file) => !file.existsSync()).map((file) => file.path).toList();
  if (missing.isNotEmpty) {
    fail('フォントがありません: ${missing.join(', ')}。先に `bash scripts/snapshot_testing/fetch_fonts.sh` を実行してください');
  }
  // 本番のコンポーネントは FontFamily.japanese と FontFamily.number (iOS のシステムフォント) を明示するため、同じ字形を割り当てる
  final families = {
    'NotoSans': files['NotoSans']!,
    'NotoSansJP': files['NotoSansJP']!,
    'NotoEmoji': files['NotoEmoji']!,
    FontFamily.japanese: files['NotoSansJP']!,
    FontFamily.number: files['NotoSans']!,
    FontFamily.roboto: files['NotoSans']!,
  };
  for (final entry in families.entries) {
    await (FontLoader(entry.key)..addFont(Future.value(ByteData.view(Uint8List.fromList(await entry.value.readAsBytes()).buffer)))).load();
  }
}

/// [lang] の言語で [child] を描く MaterialApp。グローバルの [L] と Intl の既定の言語も [lang] に切り替える。
Widget snapshotApp({required String lang, required List<Override> overrides, required Widget child}) {
  L = lookupAppLocalizations(Locale(lang));
  Intl.defaultLocale = lang;
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale(lang),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // appThemeData は最初に読まれた時のプラットフォーム (テストの既定は Android) で作られ、expectSnapshot の
      // debugDefaultTargetPlatformOverride より先に評価されるため、iOS をテーマにも明示する
      theme: appThemeData.copyWith(
        platform: TargetPlatform.iOS,
        textTheme: appThemeData.textTheme.apply(
          fontFamily: lang == 'ja' ? 'NotoSansJP' : 'NotoSans',
          fontFamilyFallback: const ['NotoSansJP', 'NotoSans', 'NotoEmoji'],
        ),
      ),
      home: child,
    ),
  );
}

/// 画面の大きさを [snapshotLogicalSize] にして [widget] を描き、[goldenName] の基準画像と比べる。
Future<void> expectSnapshot(WidgetTester tester, {required String goldenName, required Widget widget}) async {
  tester.view.physicalSize = snapshotLogicalSize * 2;
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  // アプリの利用者の大半が iOS のため、iOS の見た目 (スクロールの挙動・ページ遷移等) で描く。
  // foundation の debug 変数はテストの終わりまでに戻さないと flutter_test が fail にするため、finally で戻す
  debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  // flutter_test は既定で影を黒の塗りで描くため、本番と同じ影で描く
  debugDisableShadows = false;
  try {
    await tester.pumpWidget(widget);
    // Stream の provider の最初の値と、画像・SVG の読み込みを描画に反映させる。100ms の実時間は SVG の asset の読み込みが終わる長さ、
    // 1 秒の仮想時間は画面の出現のアニメーション (300ms 前後) が終わる長さとして選んだ (手元と CI の 10 画面で描画が揃うことを確かめた)
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/$goldenName.png'));
  } finally {
    debugDefaultTargetPlatformOverride = null;
    debugDisableShadows = true;
  }
}
