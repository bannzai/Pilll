import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:pilll/provider/typed_shared_preferences.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import './l.dart';

/// [AppLocalizationResolver] は [L] に [AppLocalizations] をセットするためのWidget
/// 毎回 AppLocalizations.of(context)! と 書いているため late で評価したものを使うのも変わらないだろうと思い作成
/// 内部処理を見たところ、contextが必要なのは初回のみLocaleからどのAppLocalizationsを使うかを決定するためだったので都度呼び出す必要はない ref: [lookupAppLocalizations]
/// > 初回のみと書いたが、おそらくOSの言語が変更されると再度評価される可能性がある。ただ、その場合も [AppLocalizationResolver] で問題ないはず。
/// なぜなら MaterialAppから再構築されてもう一回 [appLocalizations] がセットされるから
/// debug ビルドでは端末の言語ではなく [debugAppLocale] の言語を使う
class AppLocalizationResolver extends ConsumerWidget {
  final Widget Function(BuildContext) builder;
  const AppLocalizationResolver({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // buildのタイミングでセットしているが、AppLocalizations 自体は変更されてもbuildに影響を与えないため許容する
    if (kDebugMode) {
      // L は build 時に読まれるだけなので、開発者オプションで言語を変えた時に配下を描画し直させる。
      // KeyedSubtree で作り直すとタブの位置などの State が初期化されるため、State を保ったまま build だけをやり直す
      ref.listen(stringSharedPreferencesProvider(StringKey.debugAppLanguageCode), (_, __) {
        /// [element] とその配下のすべての Element を、State を保ったまま次のフレームで build し直す対象にする
        void markNeedsBuildRecursively(Element element) {
          element.markNeedsBuild();
          element.visitChildren(markNeedsBuildRecursively);
        }

        (context as Element).visitChildren(markNeedsBuildRecursively);
      });
      final locale = debugAppLocale(
        savedLanguageCode: ref.watch(stringSharedPreferencesProvider(StringKey.debugAppLanguageCode)).value,
      );
      L = lookupAppLocalizations(locale);
      // defaultLocaleもこのタイミング更新し続ける。DateFormat等に影響する
      Intl.defaultLocale = locale.languageCode;
    } else {
      L = AppLocalizations.of(context)!;
      // defaultLocaleもこのタイミング更新し続ける。DateFormat等に影響する
      Intl.defaultLocale = Localizations.localeOf(context).languageCode;
    }

    return builder(context);
  }
}

/// 端末の言語を、文言を持つ言語 ([AppLocalizations.supportedLocales]) に解決して返す。
/// UI を組み立てる前・UI の無い isolate (通知アクションのクイック記録) で [L] を決めるために使う。
/// [deviceLocales] は端末の優先言語の一覧 (`PlatformDispatcher.instance.locales`)。前面の UI の MaterialApp もこの一覧から決める。
/// [deviceLocaleName] は `Platform.localeName` の値 (例: en_US, zh_Hans_CN, fr_FR.UTF-8)。
/// UI の無い isolate で [deviceLocales] が届いているかを確かめていないため、[deviceLocales] が空の時だけその言語コードで補う。
/// 解決規則は前面の UI と同じ basicLocaleListResolution と [appSupportedLocales] にする。
Locale deviceAppLocale({required List<Locale> deviceLocales, required String deviceLocaleName}) => basicLocaleListResolution(
      deviceLocales.isNotEmpty ? deviceLocales : [Locale(deviceLocaleName.split(RegExp('[-_.@]')).first)],
      appSupportedLocales,
    );

/// MaterialApp と [deviceAppLocale] に渡す、文言を持つ言語の一覧。
/// basicLocaleListResolution は端末の言語がどれにも一致しない時に一覧の先頭を返し、
/// gen-l10n が生成する [AppLocalizations.supportedLocales] はアルファベット順で先頭が af になるため、en を先頭に置く。
/// en にした根拠: サポート外の言語の利用者は日本語の端末ではなく、ja より en の方が読める可能性が高い。
/// また app_en.arb は template の app_ja.arb のキーをすべて持つ (bannzai/Pilll#2039)。
final appSupportedLocales = [
  const Locale('en'),
  ...AppLocalizations.supportedLocales.where((locale) => locale != const Locale('en')),
];

/// [L] と [Intl.defaultLocale] を、[deviceAppLocale] で解決した端末の言語にする。引数は [deviceAppLocale] と同じ。
/// [AppLocalizationResolver] が動かない状況 (UI を組み立てる前・UI の無い isolate) で通知の文言を端末の言語にするために使う。
/// UI が組み立てられた後は [AppLocalizationResolver] が上書きする。
void applyDeviceAppLocale({required List<Locale> deviceLocales, required String deviceLocaleName}) {
  final locale = deviceAppLocale(deviceLocales: deviceLocales, deviceLocaleName: deviceLocaleName);
  L = lookupAppLocalizations(locale);
  Intl.defaultLocale = locale.languageCode;
}

/// debug ビルドの表示言語を返す。
/// [savedLanguageCode] は開発者オプションの「表示言語」で保存した arb の言語コード。
/// 保存が無い・対象言語に無い時は ja を返す (開発中は日本語の文言で確認する従来の挙動を保つため)。
Locale debugAppLocale({required String? savedLanguageCode}) => AppLocalizations.supportedLocales.firstWhere(
      (locale) => locale.languageCode == savedLanguageCode,
      orElse: () => const Locale('ja'),
    );
