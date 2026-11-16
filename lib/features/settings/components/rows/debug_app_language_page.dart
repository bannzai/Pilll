import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/features/localizations/resolver.dart';
import 'package:pilll/l10n/app_localizations.dart';
import 'package:pilll/provider/typed_shared_preferences.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/shared_preference/keys.dart';

/// debug ビルドの表示言語を対象言語 ([AppLocalizations.supportedLocales]) から選ぶページ。
/// 開発者オプションからアクセスし、端末の言語を変えずに ja 以外の文言を確認する用途 (翻訳の画面比較の撮影フロー
/// .maestro/flows/translation_screenshot/capture.yaml が各言語の行を Semantics identifier (arb の言語コード) でタップする)。
class DebugAppLanguagePage extends ConsumerWidget {
  const DebugAppLanguagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocale = debugAppLocale(
      savedLanguageCode: ref.watch(stringSharedPreferencesProvider(StringKey.debugAppLanguageCode)).value,
    );
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('表示言語'),
        backgroundColor: AppColors.background,
      ),
      body: ListView(
        children: [
          for (final locale in AppLocalizations.supportedLocales)
            Semantics(
              identifier: locale.languageCode,
              button: true,
              child: ListTile(
                title: Text(locale.languageCode),
                trailing: locale == selectedLocale ? const Icon(Icons.check) : null,
                onTap: () async {
                  analytics.logEvent(
                    name: 'debug_app_language_selected',
                    parameters: {'language_code': locale.languageCode},
                  );
                  final navigator = Navigator.of(context);
                  await ref.read(stringSharedPreferencesProvider(StringKey.debugAppLanguageCode).notifier).set(locale.languageCode);
                  navigator.pop();
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// FirebaseAnalyticsObserver が自動で screen_view を送信するため、
/// RouteSettings.name は必ず設定する。
extension DebugAppLanguagePageRoute on DebugAppLanguagePage {
  static Route<dynamic> route() => MaterialPageRoute(
        settings: const RouteSettings(name: 'DebugAppLanguagePage'),
        builder: (_) => const DebugAppLanguagePage(),
      );
}
