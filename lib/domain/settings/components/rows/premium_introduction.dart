import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/domain/premium_trial/premium_trial_complete_modal.dart';
import 'package:pilll/domain/premium_trial/premium_trial_modal.dart';

class PremiumIntroductionRow extends StatelessWidget {
  final bool isPremium;
  final DateTime? trialDeadlineDate;

  const PremiumIntroductionRow({
    Key? key,
    required this.isPremium,
    required this.trialDeadlineDate,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        analytics.logEvent(name: "tapped_premium_introduction_row");
        if (trialDeadlineDate == null) {
          showPremiumTrialModal(context, () {
            showPremiumTrialCompleteModalPreDialog(context);
          });
        } else {
          showPremiumIntroductionSheet(context);
        }
      },
      title: Text("Pilllプレミアム",
          style: FontType.assisting.merge(TextColorStyle.black)),
      trailing: isPremium ? Text("プレミアムユーザー") : null,
    );
  }
}
