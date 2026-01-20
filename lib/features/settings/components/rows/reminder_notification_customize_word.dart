import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/features/reminder_notification_customize_word/page.dart';
import 'package:pilll/entity/setting.codegen.dart';

class ReminderNotificationCustomizeWord extends HookConsumerWidget {
  final Setting setting;
  final bool isTrial;
  final bool isPremium;
  final DateTime? trialDeadlineDate;

  const ReminderNotificationCustomizeWord({
    super.key,
    required this.setting,
    required this.isTrial,
    required this.isPremium,
    required this.trialDeadlineDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      minVerticalPadding: 9,
      title: Row(
        children: [
          Text(
            L.customizeMedicationNotifications,
            style: const TextStyle(
              fontFamily: FontFamily.roboto,
              fontWeight: FontWeight.w300,
              fontSize: 16,
            ),
          ),
          if (!isPremium) ...[const SizedBox(width: 8), const PremiumBadge()],
        ],
      ),
      subtitle: Text(
        L.xCanBeCustomized(L.medicationNotification),
        style: const TextStyle(
          fontFamily: FontFamily.japanese,
          fontWeight: FontWeight.w300,
          fontSize: 14,
        ),
      ),
      onTap: () {
        analytics.logEvent(name: 'did_notification_customize_word');
        if (isTrial || isPremium) {
          Navigator.of(
            context,
          ).push(ReminderNotificationCustomizeWordPageRoutes.route());
        } else {
          showPremiumIntroductionSheet(context);
        }
      },
    );
  }
}
