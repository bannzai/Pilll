import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pilll/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import './l.dart';

/// [AppLocalizationResolver] は [L] に [AppLocalizations] をセットするためのWidget
/// 毎回 AppLocalizations.of(context)! と 書いているため late で評価したものを使うのも変わらないだろうと思い作成
/// 内部処理を見たところ、contextが必要なのは初回のみLocaleからどのAppLocalizationsを使うかを決定するためだったので都度呼び出す必要はない ref: [lookupAppLocalizations]
/// > 初回のみと書いたが、おそらくOSの言語が変更されると再度評価される可能性がある。ただ、その場合も [AppLocalizationResolver] で問題ないはず。
/// なぜなら MaterialAppから再構築されてもう一回 [appLocalizations] がセットされるから
class AppLocalizationResolver extends StatelessWidget {
  final Widget Function(BuildContext) builder;
  const AppLocalizationResolver({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    // buildのタイミングでセットしているが、AppLocalizations 自体は変更されてもbuildに影響を与えないため許容する
    if (kDebugMode) {
      L = lookupAppLocalizations(const Locale('ja'));
      // defaultLocaleもこのタイミング更新し続ける。DateFormat等に影響する
      Intl.defaultLocale = 'ja';
    } else {
      L = AppLocalizations.of(context)!;
      // defaultLocaleもこのタイミング更新し続ける。DateFormat等に影響する
      Intl.defaultLocale = Localizations.localeOf(context).languageCode;
    }

    return builder(context);
  }
}
