import 'package:flutter/material.dart';
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
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.of(context).push(DebugAppLanguagePageRoute.route());
        },
      ),
    );
  }
}
