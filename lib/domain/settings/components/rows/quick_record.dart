import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_sheet.dart';

class QuickRecordRow extends StatelessWidget {
  final bool isTrial;
  final DateTime? trialDeadlineDate;

  const QuickRecordRow({
    Key? key,
    required this.isTrial,
    required this.trialDeadlineDate,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 9,
      title: Row(
        children: const [
          Text("クイックレコード", style: FontType.listRow),
          SizedBox(width: 7),
          PremiumBadge(),
        ],
      ),
      subtitle: const Text("通知画面で今日飲むピルが分かり、そのまま服用記録できます。"),
      onTap: () {
        analytics.logEvent(
          name: "did_select_quick_record_row",
        );
        if (isTrial) {
          return;
        }
        showPremiumIntroductionSheet(context);
      },
    );
  }
}
