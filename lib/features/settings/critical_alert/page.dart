import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/local_notification.dart';

class MedicineScheduleNotificationSettingSection extends HookConsumerWidget {
  final ValueNotifier<bool> isReminderEnabled;
  final ValueNotifier<bool> isFollowupEnabled;
  final ValueNotifier<bool> useCriticalAlert;

  const MedicineScheduleNotificationSettingSection({
    super.key,
    required this.isReminderEnabled,
    required this.isFollowupEnabled,
    required this.useCriticalAlert,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MedicineFormSectionLayout(
      icon: Icons.notifications,
      text: L.notificationSetting,
      children: [
        SwitchListTile(
          value: isReminderEnabled.value,
          onChanged: (value) {
            isReminderEnabled.value = value;

            if (!value) {
              isFollowupEnabled.value = false;
            }
          },
          title: Text(L.medicationTime),
          subtitle: Text(L.medicationTimeDescription),
        ),
        SwitchListTile(
          value: isFollowupEnabled.value,
          onChanged: (value) {
            if (!isReminderEnabled.value) {
              isFollowupEnabled.value = false;
            } else {
              isFollowupEnabled.value = value;
            }
          },
          title: Text(L.enableFollowupNotification),
          subtitle: Text(L.followupNotificationDescription),
        ),
        SwitchListTile(
          value: useCriticalAlert.value,
          onChanged: (value) async {
            final grand = await localNotificationService.requestPermissionWithCriticalAlert();
            if (grand == true) {
              useCriticalAlert.value = value;
            } else {
              useCriticalAlert.value = false;
            }
          },
          title: Text(L.enableNotificationInSilentMode),
          subtitle: Text(L.silentModeNotificationDescription),
        ),
      ],
    );
  }
}
