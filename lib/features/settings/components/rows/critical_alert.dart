import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/features/settings/critical_alert/page.dart';
import 'package:pilll/utils/analytics.dart';

class CriticalAlert extends HookConsumerWidget {
  final Setting setting;
  final bool isPremium;
  final bool isTrial;
  const CriticalAlert({super.key, required this.setting, required this.isPremium, required this.isTrial});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      minVerticalPadding: 9,
      title: Row(
        children: [
          Text(
            L.enableNotificationInSilentModeSetting,
            style: const TextStyle(fontFamily: FontFamily.roboto, fontWeight: FontWeight.w300, fontSize: 16),
          ),
          if (!isPremium) ...[const SizedBox(width: 8), const PremiumBadge()],
        ],
      ),
      subtitle: Text(
        L.silentModeNotificationDescription,
        style: const TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w300, fontSize: 14),
      ),
      contentPadding: const EdgeInsets.fromLTRB(14, 4, 6, 0),
      onTap: () {
        analytics.logEvent(name: 'did_select_critical_alert_notification');
        if (isTrial || isPremium) {
          Navigator.of(context).push(CriticalAlertPageRoutes.route(setting: setting));
        } else {
          showPremiumIntroductionSheet(context);
        }
      },
    );
  }
}
