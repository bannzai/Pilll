import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/domain/settings/reminder_notification_customize_word_page.dart';
import 'package:pilll/entity/setting.codegen.dart';

class ReminderNotificationCustomizeWord extends HookConsumerWidget {
  final Setting setting;
  final bool isTrial;
  final bool isPremium;
  final DateTime? trialDeadlineDate;

  const ReminderNotificationCustomizeWord({
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
          const Text("服用通知のカスタマイズ",
              style: TextStyle(
                fontFamily: FontFamily.roboto,
                fontWeight: FontWeight.w300,
                fontSize: 16,
              )),
          if (!isPremium) ...[
            const SizedBox(width: 8),
            const PremiumBadge(),
          ]
        ],
      ),
      subtitle: const Text("服用通知の文言のカスタマイズができます", style: FontType.assisting),
      onTap: () {
        analytics.logEvent(
          name: "did_notification_customize_word",
        );
        if (isTrial || isPremium) {
          Navigator.of(context).push(ReminderNotificationCustomizeWordPageRoutes.route());
        } else {
          showPremiumIntroductionSheet(context);
        }
      },
    );
  }
}
