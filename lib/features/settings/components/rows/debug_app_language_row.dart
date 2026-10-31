import 'package:flutter/material.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/settings/components/rows/debug_app_language_page.dart';

/// 開発者オプション内の行。タップすると debug ビルドの表示言語を選ぶページに遷移する。
class DebugAppLanguageRow extends StatelessWidget {
  const DebugAppLanguageRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      identifier: 'debug_app_language_row',
      button: true,
      child: ListTile(
        title: const Text('表示言語'),
        subtitle: const Text('debug ビルドの文言の言語を切り替える'),
        // 翻訳の画面比較の撮影フロー (.maestro/flows/translation_screenshot/capture.yaml) が、選んだ言語で文言 (L) が
        // 表示されていることを Semantics identifier で確かめる。一覧の隣の言語を誤タップしても成功扱いで撮られたため (bannzai/Pilll#2059)
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              identifier: 'debug_app_language_current_${L.localeName}',
              child: Text(L.localeName),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(DebugAppLanguagePageRoute.route());
        },
      ),
    );
  }
}
