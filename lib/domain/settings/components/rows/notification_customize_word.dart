import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/domain/premium_trial/premium_trial_complete_modal.dart';
import 'package:pilll/domain/premium_trial/premium_trial_modal.dart';
import 'package:pilll/entity/setting.dart';

class NotificationCustomizeWord extends HookConsumerWidget {
  final Setting setting;
  final bool isTrial;
  final bool isPremium;
  final DateTime? trialDeadlineDate;

  const NotificationCustomizeWord({
    Key? key,
    required this.setting,
    required this.isTrial,
    required this.isPremium,
    required this.trialDeadlineDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      minVerticalPadding: 9,
      title: Row(
        children: [
          Text("服用通知のカスタマイズ", style: FontType.listRow),
          if (!isPremium) ...[
            SizedBox(width: 8),
            PremiumBadge(),
          ]
        ],
      ),
      subtitle: Text("服用通知の文言のカスタマイズができます", style: FontType.assisting),
      onTap: () {
        analytics.logEvent(
          name: "did_notification_customize_word",
        );
        if (isTrial || isPremium) {
          // TODO:
        } else {
          if (trialDeadlineDate == null) {
            showPremiumTrialModal(context, () {
              showPremiumTrialCompleteModalPreDialog(context);
            });
          } else {
            showPremiumIntroductionSheet(context);
          }
        }
      },
    );
  }
}
