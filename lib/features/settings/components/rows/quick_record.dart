import 'package:flutter/material.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/features/root/localization/l.dart'; // Lクラスをインポート

class QuickRecordRow extends StatelessWidget {
  final bool isTrial;
  final DateTime? trialDeadlineDate;

  const QuickRecordRow({
    super.key,
    required this.isTrial,
    required this.trialDeadlineDate,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 9,
      title: const Row(
        children: [
          Text(L.quickRecord, // クイックレコードを翻訳
              style: TextStyle(
                fontFamily: FontFamily.roboto,
                fontWeight: FontWeight.w300,
                fontSize: 16,
              )),
          SizedBox(width: 7),
          PremiumBadge(),
        ],
      ),
      subtitle: Text(L.quickRecordDescription), // 通知画面で今日飲むピルが分かり、そのまま服用記録できます。を翻訳
      onTap: () {
        analytics.logEvent(
          name: 'did_select_quick_record_row',
        );
        if (isTrial) {
          return;
        }
        showPremiumIntroductionSheet(context);
      },
    );
  }
}
