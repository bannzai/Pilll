import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/utils/local_notification.dart';

class ToggleLocalNotification extends HookConsumerWidget {
  final User user;

  const ToggleLocalNotification({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateUseLocalNotification = ref.watch(updateUseLocalNotificationProvider);
    final registerReminderLocalNotification = ref.watch(registerReminderLocalNotificationProvider);
    final cancelReminderLocalNotification = ref.watch(cancelReminderLocalNotificationProvider);

    return SwitchListTile(
      title: const Text("服薬通知βを使用する",
          style: TextStyle(
            fontFamily: FontFamily.roboto,
            fontWeight: FontWeight.w300,
            fontSize: 16,
          )),
      activeColor: PilllColors.secondary,
      onChanged: (bool value) async {
        analytics.logEvent(
          name: "toggle_local_notification",
        );
        final messenger = ScaffoldMessenger.of(context);
        messenger.hideCurrentSnackBar();
        try {
          await updateUseLocalNotification(user, value);

          if (value) {
            await registerReminderLocalNotification();
          } else {
            await cancelReminderLocalNotification();
          }

          messenger.showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              content: Text(
                "服薬通知βを利用するを ${value ? "ON" : "OFF"}にしました",
              ),
            ),
          );
        } catch (error) {
          if (context.mounted) showErrorAlert(context, error);
        }
      },
      value: user.useLocalNotificationForReminder,
      // NOTE: when configured subtitle, the space between elements becomes very narrow
      contentPadding: const EdgeInsets.fromLTRB(14, 4, 6, 0),
    );
  }
}
