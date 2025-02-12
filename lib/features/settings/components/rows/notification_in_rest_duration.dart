import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/utils/local_notification.dart';

class NotificationInRestDuration extends HookConsumerWidget {
  final PillSheet pillSheet;
  final Setting setting;

  const NotificationInRestDuration({
    super.key,
    required this.pillSheet,
    required this.setting,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setSetting = ref.watch(setSettingProvider);
    final registerReminderLocalNotification = ref.watch(registerReminderLocalNotificationProvider);

    return SwitchListTile(
      title: Text('${pillSheet.pillSheetType.notTakenWord}期間の通知',
          style: const TextStyle(
            fontFamily: FontFamily.roboto,
            fontWeight: FontWeight.w300,
            fontSize: 16,
          )),
      subtitle: Text(
        L.autoRecordForNotTakenPeriodIfNotificationOff(pillSheet.pillSheetType.notTakenWord),
        style: const TextStyle(
          fontFamily: FontFamily.japanese,
          fontWeight: FontWeight.w300,
          fontSize: 14,
        ),
      ),
      activeColor: AppColors.secondary,
      onChanged: (bool value) async {
        analytics.logEvent(
          name: 'toggle_notify_not_taken_duration',
        );
        final messenger = ScaffoldMessenger.of(context);
        messenger.hideCurrentSnackBar();
        await setSetting(setting.copyWith(isOnNotifyInNotTakenDuration: value));
        await registerReminderLocalNotification();
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            content: Text(
              "${pillSheet.pillSheetType.notTakenWord}期間の通知を${value ? "ON" : "OFF"}にしました",
            ),
          ),
        );
      },
      value: setting.isOnNotifyInNotTakenDuration,
      // NOTE: when configured subtitle, the space between elements becomes very narrow
      contentPadding: const EdgeInsets.fromLTRB(14, 8, 6, 8),
    );
  }
}
