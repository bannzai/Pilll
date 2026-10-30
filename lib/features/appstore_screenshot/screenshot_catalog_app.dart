import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pilll/features/appstore_screenshot/screenshot_autoplay.dart';
import 'package:pilll/features/appstore_screenshot/screenshot_device.dart';
import 'package:pilll/features/appstore_screenshot/screenshot_locale.dart';
import 'package:pilll/features/appstore_screenshot/screenshot_page.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/l10n/app_localizations.dart';

/// App Store スクリーンショットを Simulator 上で実描画・実撮影するためのカタログアプリ。
///
/// widget test レンダラは実機のフォント・絵文字と見た目が異なるため、正式な生成経路は
/// この Catalog を Simulator に載せて OS スクリーンショットを撮る方式にする。
/// main.dev.dart が `--dart-define=SCREENSHOT_CATALOG=true` のときに entrypoint を通さず
/// このアプリを runApp する。
///
/// 画面遷移: 言語一覧 → ページ一覧(p1〜p7) → 全画面プレビュー。
/// Maestro からタップできるよう、各行に Semantics identifier（言語は arb コード、
/// ページは page_N、戻るは back）を付ける。言語選択でグローバル [L] と Localizations を
/// 実行時に差し替える。
///
/// 全画面プレビューは載っている Simulator の画面の縦横比から [ScreenshotDevice] を選ぶため、
/// iPhone 15 Pro Max（1290×2796）と iPhone Duo の外側（1398×2034）・内側（2853×2007）を
/// 同じビルドで撮れる。ホスト側のスクリプトからの無人操作は [runScreenshotAutoplayIfRequested]。
class ScreenshotCatalogApp extends StatelessWidget {
  const ScreenshotCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: catalogLocale,
      builder: (context, locale, _) {
        return MaterialApp(
          navigatorKey: catalogNavigatorKey,
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

/// 無人操作（[runScreenshotAutoplayIfRequested]）が全画面プレビューを push するための Navigator。
final GlobalKey<NavigatorState> catalogNavigatorKey = GlobalKey<NavigatorState>();

/// グローバル [L]・[Intl.defaultLocale] (DateTimeFormatter の日付書式の言語) とカタログのロケールを [lang] へ切り替える。
/// 言語一覧のタップと無人操作が共用する。
void applyCatalogLanguage(String lang) {
  L = lookupAppLocalizations(Locale(lang));
  Intl.defaultLocale = lang;
  catalogLocale.value = Locale(lang);
}

/// 無人操作の依頼ファイルがあれば、Navigator の準備を待ってから各ページを順に全画面表示する。
///
/// main.dev.dart が runApp の直後に呼ぶ。依頼ファイルの形式と同期手順は screenshot_autoplay.dart。
Future<void> runCatalogAutoplayIfRequested() {
  return runScreenshotAutoplayIfRequested(
    applyLanguage: applyCatalogLanguage,
    pushPage: ({required lang, required page, required documents}) async {
      while (catalogNavigatorKey.currentState == null) {
        await Future<void>.delayed(ackPollInterval);
      }
      final route = MaterialPageRoute<void>(builder: (_) => _FullScreenPage(lang: lang, page: page, autoplayDocuments: documents));
      await catalogNavigatorKey.currentState!.push(route);
      // push の Future は pop の時点で完了し、閉じるアニメーションの後に走る前ページの dispose
      // （SystemUiMode を edgeToEdge に戻す）を待たない。そのまま次ページを push すると、次ページの
      // initState で隠したシステム UI を前ページの dispose が戻してしまう。route.completed は
      // Navigator が overlay の unmount（= State.dispose）を待ってから route を dispose した時に
      // 完了する（flutter/lib/src/widgets/navigator.dart の _RouteEntry.dispose、
      // routes.dart の TransitionRoute.dispose）ため、これを待ってから次ページへ進む。
      await route.completed;
    },
  );
}

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
                  applyCatalogLanguage(lang);
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
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => _FullScreenPage(lang: lang, page: page, autoplayDocuments: null)));
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
/// 合成ページの寸法は、端末画面の論理サイズに縦横比が最も近い [ScreenshotDevice] から選ぶ。
/// iPhone 6.7"（430×932pt @3x）では 1290×2796、iPhone Duo の外側（466×678pt）では
/// 1398×2034、内側（951×669pt、横）では 2853×2007 の合成ページを画面いっぱいに縮小表示し、
/// OS スクリーンショットがそのままストアの寸法になる。
///
/// [autoplayDocuments] が non-null なら無人操作で、描画後にホストへ知らせて撮影完了を待ってから
/// 自分で閉じる（screenshot_autoplay.dart）。
class _FullScreenPage extends StatefulWidget {
  const _FullScreenPage({required this.lang, required this.page, required this.autoplayDocuments});

  /// 選択中の arb 言語コード。
  final String lang;

  /// 表示するページ番号。
  final int page;

  /// 無人操作の同期ファイルを置く Documents ディレクトリ。Maestro 等の手動操作では null。
  final Directory? autoplayDocuments;

  @override
  State<_FullScreenPage> createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<_FullScreenPage> {
  @override
  void initState() {
    super.initState();
    // ステータスバー・ホームインジケータを隠して合成ページだけを撮れるようにする。
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    final documents = widget.autoplayDocuments;
    if (documents != null) {
      // 最初のフレームの描画後にホストへ知らせる。画像アセット等の非同期読み込みの余裕は
      // ホスト側が撮影前に待つ（capture_duo_screenshots.sh）。
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await notifyReadyAndWaitForAck(documents: documents, lang: widget.lang, page: widget.page);
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final device = screenshotDeviceForScreen(screenSize: MediaQuery.sizeOf(context));
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: device.outputWidth,
                height: device.outputHeight,
                child: screenshotPage(lang: widget.lang, page: widget.page, device: device),
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
