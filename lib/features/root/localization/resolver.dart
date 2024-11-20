import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pilll/features/root/localization/l.dart';

/// [AppLocalizationResolver] は グローバルな [L] 変数に [AppLocalizations] をセットするためのWidget
/// 
/// MaterialAppの子孫として配置することで、アプリ全体で利用可能な翻訳リソースを提供します。
/// OSの言語設定が変更された場合も、MaterialAppの再構築により自動的に適切な翻訳が設定されます。
class AppLocalizationResolver extends StatelessWidget {
  const AppLocalizationResolver({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    L = AppLocalizations.of(context)!;
    return child;
  }
}
