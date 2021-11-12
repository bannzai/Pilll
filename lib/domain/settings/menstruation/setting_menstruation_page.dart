import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/template/setting_menstruation/setting_menstruation_dynamic_description.dart';
import 'package:pilll/components/template/setting_menstruation/setting_menstruation_page_template.dart';
import 'package:pilll/components/template/setting_menstruation/setting_menstruation_pill_sheet_list.dart';
import 'package:pilll/domain/settings/menstruation/setting_menstruation_store.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';

class SettingMenstruationPage extends HookWidget {
  const SettingMenstruationPage({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final store = useProvider(settingMenstruationStoreProvider);
    final settingState = useProvider(settingStateProvider);
    final setting = settingState.entity;
    if (setting == null) {
      throw FormatException("生理設定にはSettingのデータが必要です");
    }
    return SettingMenstruationPageTemplate(
      title: "生理について",
      pillSheetList: SettingMenstruationPillSheetList(
        pillSheetTypes: setting.pillSheetTypes,
        appearanceMode: setting.pillSheetAppearanceMode,
        selectedPillNumber: (pageIndex) =>
            store.retrieveMenstruationSelectedPillNumber(setting, pageIndex),
        markSelected: (pageIndex, number) {
          analytics.logEvent(name: "from_menstruation_setting", parameters: {
            "number": number,
            "page": pageIndex,
          });
          store.modifyFromMenstruation(
            setting: setting,
            pageIndex: pageIndex,
            fromMenstruation: number,
          );
        },
      ),
      dynamicDescription: SettingMenstruationDynamicDescription(
        pillSheetTypes: setting.pillSheetTypes,
        fromMenstruation: setting.pillNumberForFromMenstruation,
        fromMenstructionDidDecide: (number) {
          analytics.logEvent(
              name: "from_menstruation_initial_setting",
              parameters: {"number": number});
          store.modifyFromMenstruationFromPicker(
            setting: setting,
            serializedPillNumberIntoGroup: number,
          );
        },
        durationMenstruation: setting.durationMenstruation,
        durationMenstructionDidDecide: (number) {
          analytics.logEvent(
              name: "duration_menstruation_initial_setting",
              parameters: {"number": number});
          store.modifyDurationMenstruation(
            setting: setting,
            durationMenstruation: number,
          );
        },
      ),
      doneButton: null,
    );
  }
}

extension SettingMenstruationPageRoute on SettingMenstruationPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: "SettingMenstruationPage"),
      builder: (_) => SettingMenstruationPage(),
    );
  }
}
