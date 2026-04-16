import 'package:flutter/material.dart';
import 'package:pilll/features/settings/components/rows/feature_appeal_help_page_list_page.dart';

/// 開発者オプション内の行。タップすると FeatureAppeal HelpPage 一覧ページに遷移する。
class FeatureAppealHelpPageListRow extends StatelessWidget {
  const FeatureAppealHelpPageListRow({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('FeatureAppeal HelpPage 一覧'),
      subtitle: const Text('各機能のヘルプページを確認'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.of(context).push(FeatureAppealHelpPageListPageRoute.route());
      },
    );
  }
}
