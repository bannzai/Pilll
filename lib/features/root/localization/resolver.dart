import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pilll/features/root/localization/l.dart';

/// [AppLocalizationResolver] は [L] に [AppLocalizations] をセットするためのWidget
/// 毎回 AppLocalizations.of(context)! と 書いているため late で評価したものを使うのも変わらないだろうと思い作成
/// 内部処理を見たところ、contextが必要なのは初回のみLocaleからどのAppLocalizationsを使うかを決定するためだったので都度呼び出す必要はない ref: [lookupAppLocalizations]
/// > 初回のみと書いたが、おそらくOSの言語が変更されると再度評価される可能性がある。ただ、その場合も [AppLocalizationResolver] で問題ないはず。
/// なぜなら MaterialAppから再構築されてもう一回 [appLocalizations] がセットされるから
class AppLocalizationResolver extends StatelessWidget {
  const AppLocalizationResolver({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // buildのタイミングでセットしているが、AppLocalizations 自体は変更されてもbuildに影響を与えないため許容する
    L = AppLocalizations.of(context)!;
    return child;
  }
}
