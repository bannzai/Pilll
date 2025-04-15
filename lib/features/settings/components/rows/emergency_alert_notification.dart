import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/settings/emergency_alert_notification/page.dart';
import 'package:pilll/utils/analytics.dart';

class EmergencyAlertNotification extends HookConsumerWidget {
  const EmergencyAlertNotification({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(
        '緊急アラート',
        style: const TextStyle(
          fontFamily: FontFamily.roboto,
          fontWeight: FontWeight.w300,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      contentPadding: const EdgeInsets.fromLTRB(14, 4, 6, 0),
      onTap: () {
        analytics.logEvent(
          name: 'did_select_emergency_alert_notification',
        );
        Navigator.of(context).push(EmergencyAlertNotificationPage.route());
      },
    );
  }
}
