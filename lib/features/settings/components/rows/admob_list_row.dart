import 'package:flutter/material.dart';
import 'package:pilll/features/settings/components/rows/admob_list_page.dart';

/// 開発者オプション内の行。タップすると AdMob 一覧ページに遷移する。
class AdMobListRow extends StatelessWidget {
  const AdMobListRow({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('AdMob 一覧'),
      subtitle: const Text('バナー・ネイティブ広告の表示を確認'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.of(context).push(AdMobListPageRoute.route());
      },
    );
  }
}
