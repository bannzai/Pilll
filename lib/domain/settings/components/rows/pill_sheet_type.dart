import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_type_select_page.dart';
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
    final pillSheetType = state.setting?.legacyPropertyForPillSheetType;
    assert(pillSheetType != null);
    if (pillSheetType == null) {
      return Container();
    }
    return ListTile(
      title: Text("ピルシートタイプ", style: FontType.listRow),
      subtitle: Text(state.setting?.legacyPropertyForPillSheetType.fullName ?? ""),
      onTap: () {
        analytics.logEvent(
          name: "did_select_changing_pill_sheet_type",
        );
        if (latestPillSheetGroup != null) {
          final word = latestPillSheetGroup.pillSheets.length == 1
              ? "ピルシート"
              : "ピルシートグループ";
          showOKDialog(
            context,
            title: "ピルシートタイプを変更するには",
            message: "現在服用中の$wordを破棄した後にピルシートタイプの変更をお試しください",
          );
        } else {
          Navigator.of(context).push(
            PillSheetTypeSelectPageRoute.route(
              title: "ピルシートタイプ",
              backButtonIsHidden: false,
              selected: (type) async {
                await store.modifyPillSheetType(pillSheetType);
                Navigator.pop(context);
              },
              done: null,
              doneButtonText: "",
              selectedPillSheetType: pillSheetType,
              signinAccount: null,
            ),
          );
        }
      },
    );
  }
}
