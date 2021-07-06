import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/organisms/pill/pill_sheet_type_select_page.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/domain/settings/components/rows/pill_sheet_type_store.dart';
import 'package:pilll/domain/settings/setting_page_state.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class PillSheetTypeRow extends StatelessWidget {
  final SettingState settingState;

  const PillSheetTypeRow({
    Key? key,
    required this.settingState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = useProvider(pillSheetTypeStoreProvider(settingState));
    final state = useProvider(pillSheetTypeStoreProvider(settingState).state);
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
              if (store.shouldShowDiscardDialog(type)) {
                showDialog(
                  context: context,
                  builder: (_) {
                    return DiscardDialog(
                        title: "現在のピルシートが削除されます",
                        message: '''
選択したピルシート(${type.fullName})に変更する場合、現在のピルシートは削除されます。削除後、ピル画面から新しいピルシートを作成すると${type.fullName}で開始されます。
現在のピルシートを削除してピルシートのタイプを変更しますか？
                              ''',
                        doneButtonText: "変更する",
                        done: () async {
                          await _modifyProcess(context, store, type);
                        });
                  },
                );
              } else {
                await _modifyProcess(context, store, type);
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

  Future<void> _modifyProcess(
    BuildContext context,
    PillSheetTypeStateStore store,
    PillSheetType pillSheetType,
  ) async {
    await store.modifyPillSheetType(pillSheetType);
    Navigator.pop(context);
  }
}
