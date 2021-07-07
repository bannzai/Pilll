import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/entity/setting.dart';

class PillSheetAppearanceModeRow extends HookWidget {
  final Setting setting;

  const PillSheetAppearanceModeRow({
    Key? key,
    required this.setting,
  }) : super(key: key);

  // TODO: add premium introduction logic
  @override
  Widget build(BuildContext context) {
    final store = useProvider(settingStoreProvider);
    return SwitchListTile(
      title: Text("日付表示モード", style: FontType.listRow),
      value: setting.pillSheetAppearanceMode == PillSheetAppearanceMode.date,
      onChanged: (value) {
        analytics.logEvent(
          name: "did_select_pill_sheet_appearance",
        );
        final pillSheetAppearanceMode = value
            ? PillSheetAppearanceMode.date
            : PillSheetAppearanceMode.number;
        store.modifyPillSheetAppearanceMode(pillSheetAppearanceMode);
      },
    );
  }
}
