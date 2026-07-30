import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pilll/features/appstore_screenshot/screenshot_device.dart';
import 'package:pilll/features/appstore_screenshot/screenshot_locale.dart';
import 'package:pilll/features/appstore_screenshot/screenshot_page.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/l10n/app_localizations.dart';

/// App Store スクリーンショットを Simulator 上で実描画・実撮影するためのカタログアプリ。
///
/// widget test レンダラは実機のフォント・絵文字と見た目が異なるため、正式な生成経路は
/// この Catalog を Simulator に載せて OS スクリーンショット（1290×2796 px）を撮る方式にする。
/// main.dev.dart が `--dart-define=SCREENSHOT_CATALOG=true` のときに entrypoint を通さず
/// このアプリを runApp する。
///
/// 画面遷移: 言語一覧 → ページ一覧(p1〜p5) → 全画面プレビュー。
/// Maestro からタップできるよう、各行に Semantics identifier（言語は arb コード、
/// ページは page_N、戻るは back）を付ける。言語選択でグローバル [L] と Localizations を
/// 実行時に差し替える。
class ScreenshotCatalogApp extends StatelessWidget {
  const ScreenshotCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: catalogLocale,
      builder: (context, locale, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          // 実 iOS のシステムフォントで描画させるため、テスト用のフォント指定はしない。
          theme: ThemeData(useMaterial3: false),
          home: const _LanguageListPage(),
        );
      },
    );
  }
}

/// カタログ全体で共有する現在ロケール。言語選択で差し替えると MaterialApp が再ビルドされ、
/// Localizations（RTL 含む）が切り替わる。
final ValueNotifier<Locale> catalogLocale = ValueNotifier<Locale>(Locale(allScreenshotLanguages.first));

/// 言語一覧ページ。各行タップで L・ロケールを差し替えてページ一覧へ進む。
class _LanguageListPage extends StatelessWidget {
  const _LanguageListPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screenshot Catalog')),
      body: ListView(
        children: [
          for (final lang in allScreenshotLanguages)
            Semantics(
              identifier: lang,
              button: true,
              child: ListTile(
                title: Text(lang),
                subtitle: Text(fastlaneLocaleOf(lang: lang)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  L = lookupAppLocalizations(Locale(lang));
                  catalogLocale.value = Locale(lang);
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => _PageListPage(lang: lang)));
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// ページ一覧ページ（p1〜p[allScreenshotPageCount]）。各行タップで全画面プレビューへ進む。
class _PageListPage extends StatelessWidget {
  const _PageListPage({required this.lang});

  /// 選択中の arb 言語コード。
  final String lang;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$lang pages')),
      body: ListView(
        children: [
          for (var page = 1; page <= allScreenshotPageCount; page++)
            Semantics(
              identifier: 'page_$page',
              button: true,
              child: ListTile(
                title: Text('page $page'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => _FullScreenPage(lang: lang, page: page)));
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// 全画面プレビュー。合成ページ（frame_layout + Mock）を端末画面いっぱいに拡大表示し、
/// ステータスバーを隠す。下端の透明な帯（identifier: back）で戻る。
///
/// iPhone 6.7"（430×932pt @3x = 1290×2796px）では合成ページ（論理 1290×2796）を
/// 画面いっぱいに縮小表示すると、OS スクリーンショットが 1290×2796px になる。
class _FullScreenPage extends StatefulWidget {
  const _FullScreenPage({required this.lang, required this.page});

  /// 選択中の arb 言語コード。
  final String lang;

  /// 表示するページ番号。
  final int page;

  @override
  State<_FullScreenPage> createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<_FullScreenPage> {
  @override
  void initState() {
    super.initState();
    // ステータスバー・ホームインジケータを隠して合成ページだけを撮れるようにする。
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: ScreenshotDevice.iPhone67.outputWidth,
                height: ScreenshotDevice.iPhone67.outputHeight,
                child: screenshotPage(lang: widget.lang, page: widget.page, device: ScreenshotDevice.iPhone67),
              ),
            ),
          ),
          // 下端の透明な戻る領域（Maestro から identifier=back でタップ）。
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 64,
            child: Semantics(
              identifier: 'back',
              button: true,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).pop(),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
