import 'package:flutter/material.dart';
import 'package:pilll/features/settings/components/rows/feature_appeal_announcement_bar_list_page.dart';

/// 開発者オプション内の行。タップすると FeatureAppeal AnnouncementBar 一覧ページに遷移する。
class FeatureAppealAnnouncementBarListRow extends StatelessWidget {
  const FeatureAppealAnnouncementBarListRow({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('FeatureAppeal AnnouncementBar 一覧'),
      subtitle: const Text('各機能のアナウンスバーを確認'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.of(context).push(FeatureAppealAnnouncementBarListPageRoute.route());
      },
    );
  }
}
