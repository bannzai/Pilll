import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/organisms/pill/pill_sheet_type_select_page.dart';
import 'package:pilll/components/page/ok_dialog.dart';
import 'package:pilll/domain/settings/components/rows/pill_sheet_type_store.dart';
import 'package:pilll/domain/settings/setting_page_state.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class PillSheetTypeRow extends HookWidget {
  final SettingState settingState;

  const PillSheetTypeRow({
    Key? key,
    required this.settingState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = useProvider(pillSheetTypeStoreProvider(settingState));
    final state = useProvider(pillSheetTypeStoreProvider(settingState).state);
    final latestPillSheetGroup = settingState.latestPillSheetGroup;
    final pillSheetType = state.setting?.pillSheetType;
    assert(pillSheetType != null);
    if (pillSheetType == null) {
      return Container();
    }
    return ListTile(
      title: Text("ピルシートタイプ", style: FontType.listRow),
      subtitle: Text(state.setting?.pillSheetType.fullName ?? ""),
      onTap: () {
        analytics.logEvent(
          name: "did_select_changing_pill_sheet_type",
        );
        Navigator.of(context).push(
          PillSheetTypeSelectPageRoute.route(
            title: "ピルシートタイプ",
            backButtonIsHidden: false,
            selected: (type) async {
              if (latestPillSheetGroup != null) {
                final word = latestPillSheetGroup.pillSheets.length == 1
                    ? "ピルシート"
                    : "ピルシートグループ";
                showOKDialog(
                  context,
                  title: "ピルシートタイプを変更するには",
                  message:
                      "現在進行中$wordがある場合はピルシートタイプを変更できません。$wordを破棄した後にピルシートタイプの変更をお試しください",
                );
              } else {
                await store.modifyPillSheetType(pillSheetType);
                Navigator.pop(context);
              }
            },
            done: null,
            doneButtonText: "",
            selectedPillSheetType: pillSheetType,
            signinAccount: null,
          ),
        );
      },
    );
  }
}
