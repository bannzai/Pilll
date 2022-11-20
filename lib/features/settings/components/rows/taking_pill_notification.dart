import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/util/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/provider/setting.dart';

class TakingPillNotification extends HookConsumerWidget {
  final Setting setting;

  const TakingPillNotification({
    Key? key,
    required this.setting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setSetting = ref.watch(setSettingProvider);

    return SwitchListTile(
      title: const Text("ピルの服用通知",
          style: TextStyle(
            fontFamily: FontFamily.roboto,
            fontWeight: FontWeight.w300,
            fontSize: 16,
          )),
      activeColor: PilllColors.secondary,
      onChanged: (bool value) async {
        analytics.logEvent(
          name: "did_select_toggle_reminder",
        );
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        try {
          await setSetting(setting.copyWith(isOnReminder: value));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              content: Text(
                "服用通知を${value ? "ON" : "OFF"}にしました",
              ),
            ),
          );
        } catch (error) {
          showErrorAlert(context, error);
        }
      },
      value: setting.isOnReminder,
      // NOTE: when configured subtitle, the space between elements becomes very narrow
      contentPadding: const EdgeInsets.fromLTRB(14, 4, 6, 0),
    );
  }
}
