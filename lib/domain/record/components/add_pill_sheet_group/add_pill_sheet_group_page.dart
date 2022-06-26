import 'package:flutter/material.dart';

import 'package:pilll/analytics.dart';
import 'package:pilll/components/template/setting_pill_sheet_group/setting_pill_sheet_group.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/domain/record/components/add_pill_sheet_group/add_pill_sheet_group_store.dart';
import 'package:pilll/domain/record/components/add_pill_sheet_group/display_number_setting.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class AddPillSheetGroupPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(addPillSheetGroupStateStoreProvider.notifier);
    final state = ref.watch(addPillSheetGroupStateStoreProvider);
    final setting = state.setting;
    if (setting == null) {
      throw const FormatException("ピルシートグループの設定が読み込めませんでした");
    }

    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "ピルシート追加",
          style: TextStyle(color: TextColor.black),
        ),
        backgroundColor: PilllColors.white,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Stack(
            children: [
              SettingPillSheetGroup(
                pillSheetTypes: setting.pillSheetEnumTypes,
                onAdd: (pillSheetType) {
                  analytics.logEvent(
                      name: "setting_add_pill_sheet_group",
                      parameters: {"pill_sheet_type": pillSheetType.fullName});
                  store.addPillSheetType(pillSheetType, setting);
                },
                onChange: (index, pillSheetType) {
                  analytics.logEvent(
                      name: "setting_change_pill_sheet_group",
                      parameters: {
                        "index": index,
                        "pill_sheet_type": pillSheetType.fullName
                      });
                  store.changePillSheetType(index, pillSheetType, setting);
                },
                onDelete: (index) {
                  analytics.logEvent(
                      name: "setting_delete_pill_sheet_group",
                      parameters: {"index": index});
                  store.removePillSheetType(index, setting);
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 35),
                  child: Container(
                    color: PilllColors.background,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DisplayNumberSetting(store: store, state: state),
                        const SizedBox(height: 24),
                        PrimaryButton(
                          text: "追加",
                          onPressed: () async {
                            analytics.logEvent(
                                name: "pressed_add_pill_sheet_group");
                            store.register(setting);

                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }
}

extension AddPillSheetGroupPageRoute on AddPillSheetGroupPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      settings: const RouteSettings(name: "RecordPageAddingPillSheetGroupPage"),
      builder: (_) => AddPillSheetGroupPage(),
    );
  }
}
