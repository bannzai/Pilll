import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/entity/setting.dart';

class CreatingNewPillSheetRow extends HookWidget {
  final Setting setting;

  const CreatingNewPillSheetRow({
    Key? key,
    required this.setting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = useProvider(settingStoreProvider);
    return SwitchListTile(
      title: Text("ピルシートの自動作成", style: FontType.listRow),
      activeColor: PilllColors.primary,
      onChanged: (bool value) {
        analytics.logEvent(
          name: "toggle_creating_new_pillsheet",
        );
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        store
            .modifiyIsAutomaticallyCreatePillSheet(
                !setting.isAutomaticallyCreatePillSheet)
            .then((state) {
          final setting = state.entity;
          if (setting == null) {
            return null;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 2),
              content: Text(
                "ピルシートの自動作成を${setting.isAutomaticallyCreatePillSheet ? "ON" : "OFF"}にしました",
              ),
            ),
          );
        });
      },
      value: setting.isAutomaticallyCreatePillSheet,
      // NOTE: when configured subtitle, the space between elements becomes very narrow
      contentPadding: EdgeInsets.fromLTRB(14, 8, 6, 8),
    );
  }
}
