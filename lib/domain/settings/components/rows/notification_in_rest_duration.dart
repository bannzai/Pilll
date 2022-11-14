import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/domain/settings/setting_page_state_notifier.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/error/error_alert.dart';
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
      title: Text("${pillSheet.pillSheetType.notTakenWord}期間の通知", style: FontType.listRow),
      subtitle: Text("通知オフの場合は、${pillSheet.pillSheetType.notTakenWord}期間の服用記録も自動で付けられます", style: FontType.assisting),
      activeColor: PilllColors.primary,
      onChanged: (bool value) async {
        analytics.logEvent(
          name: "toggle_notify_not_taken_duration",
        );
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        await setSetting(setting.copyWith(isOnNotifyInNotTakenDuration: value));
        ScaffoldMessenger.of(context).showSnackBar(
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
