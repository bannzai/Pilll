import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';

class NotificationInRestDuration extends HookWidget {
  final PillSheet pillSheet;
  final Setting setting;

  const NotificationInRestDuration({
    Key? key,
    required this.pillSheet,
    required this.setting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = useProvider(settingStoreProvider);
    return SwitchListTile(
      title: Text("${pillSheet.pillSheetType.notTakenWord}期間の通知",
          style: FontType.listRow),
      subtitle: Text(
          "通知オフの場合は、${pillSheet.pillSheetType.notTakenWord}期間の服用記録も自動で付けられます",
          style: FontType.assisting),
      activeColor: PilllColors.primary,
      onChanged: (bool value) {
        analytics.logEvent(
          name: "toggle_notify_not_taken_duration",
        );
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        store
            .modifyIsOnNotifyInNotTakenDuration(
                !setting.isOnNotifyInNotTakenDuration)
            .then((state) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 2),
              content: Text(
                "${pillSheet.pillSheetType.notTakenWord}期間の通知を${state.setting!.isOnNotifyInNotTakenDuration ? "ON" : "OFF"}にしました",
              ),
            ),
          );
        });
      },
      value: setting.isOnNotifyInNotTakenDuration,
      // NOTE: when configured subtitle, the space between elements becomes very narrow
      contentPadding: EdgeInsets.fromLTRB(14, 8, 6, 8),
    );
  }
}
