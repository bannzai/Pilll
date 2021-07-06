import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/domain/settings/setting_page_state.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/util/toolbar/picker_toolbar.dart';

class PillSheetAppearanceModeRow extends HookWidget {
  final SettingState settingState;

  const PillSheetAppearanceModeRow({
    Key? key,
    required this.settingState,
  }) : super(key: key);

  // TODO: add premium introduction logic
  @override
  Widget build(BuildContext context) {
    final setting = settingState.entity;
    if (setting == null) {
      return Container();
    }
    final store = useProvider(settingStoreProvider);
    return ListTile(
      title: Text("表示モード", style: FontType.listRow),
      subtitle: Text(setting.pillSheetAppearanceMode.itemName),
      onTap: () {
        analytics.logEvent(
          name: "did_select_setting_pill_sheet_appearance",
        );
        var selected = setting.pillSheetAppearanceMode;
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                PickerToolbar(
                  done: (() {
                    analytics.logEvent(
                        name: "done_setting_pill_sheet_appearance",
                        parameters: {
                          "before": setting.pillSheetAppearanceMode.itemName,
                          "after": selected.itemName,
                        });
                    store.modifyPillSheetAppearanceMode(selected);
                    Navigator.pop(context);
                  }),
                  cancel: (() {
                    Navigator.pop(context);
                  }),
                ),
                Container(
                  height: 200,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CupertinoPicker(
                      itemExtent: 40,
                      children: PillSheetAppearanceMode.values
                          .map((v) => Text(v.itemName))
                          .toList(),
                      onSelectedItemChanged: (index) {
                        selected = PillSheetAppearanceMode.values[index];
                      },
                      scrollController: FixedExtentScrollController(
                        initialItem: setting.pillSheetAppearanceMode.index,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
