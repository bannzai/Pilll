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
      final locale = debugAppLocale(
        savedLanguageCode: ref.watch(stringSharedPreferencesProvider(StringKey.debugAppLanguageCode)).value,
      );
      L = lookupAppLocalizations(locale);
      // defaultLocaleもこのタイミング更新し続ける。DateFormat等に影響する
      Intl.defaultLocale = locale.languageCode;
      // L は build 時に読まれるだけなので、開発者オプションで言語を変えた時に配下を作り直して新しい言語で描画させる
      return KeyedSubtree(key: ValueKey(locale), child: builder(context));
    } else {
      L = AppLocalizations.of(context)!;
      // defaultLocaleもこのタイミング更新し続ける。DateFormat等に影響する
      Intl.defaultLocale = Localizations.localeOf(context).languageCode;
    }

    return builder(context);
  }
}

/// debug ビルドの表示言語を返す。
/// [savedLanguageCode] は開発者オプションの「表示言語」で保存した arb の言語コード。
/// 保存が無い・対象言語に無い時は ja を返す (開発中は日本語の文言で確認する従来の挙動を保つため)。
Locale debugAppLocale({required String? savedLanguageCode}) => AppLocalizations.supportedLocales.firstWhere(
      (locale) => locale.languageCode == savedLanguageCode,
      orElse: () => const Locale('ja'),
    );
