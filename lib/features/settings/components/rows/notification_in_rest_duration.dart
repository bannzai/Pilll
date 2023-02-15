import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/setting.dart';

class NotificationInRestDuration extends HookConsumerWidget {
  final PillSheet pillSheet;
  final Setting setting;

  const NotificationInRestDuration({
    Key? key,
    required this.pillSheet,
    required this.setting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setSetting = ref.watch(setSettingProvider);
    return SwitchListTile(
      title: Text("${pillSheet.pillSheetType.notTakenWord}期間の通知",
          style: const TextStyle(
            fontFamily: FontFamily.roboto,
            fontWeight: FontWeight.w300,
            fontSize: 16,
          )),
      subtitle: Text("通知オフの場合は、${pillSheet.pillSheetType.notTakenWord}期間の服用記録も自動で付けられます",
          style: const TextStyle(
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w300,
            fontSize: 14,
          )),
      activeColor: PilllColors.secondary,
      onChanged: (bool value) async {
        analytics.logEvent(
          name: "toggle_notify_not_taken_duration",
        );
        final messenger = ScaffoldMessenger.of(context);
        messenger.hideCurrentSnackBar();
        await setSetting(setting.copyWith(isOnNotifyInNotTakenDuration: value));
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
