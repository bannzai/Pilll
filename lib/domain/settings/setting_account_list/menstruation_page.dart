import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/organisms/pill_sheet/setting_pill_sheet_view.dart';
import 'package:pilll/components/template/setting_menstruation/setting_menstruation_dynamic_description.dart';
import 'package:pilll/components/template/setting_menstruation/setting_menstruation_page_template.dart';
import 'package:pilll/components/template/setting_menstruation/setting_menstruation_pill_sheet_list.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';

class SettingMenstruationPage extends HookWidget {
  const SettingMenstruationPage({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final store = useProvider(settingStoreProvider);
    final state = useProvider(settingStoreProvider.state);
    final setting = state.entity;
    if (setting == null) {
      throw FormatException("生理設定にはSettingのデータが必要です");
    }
    int currentPage = 0;
    return SettingMenstruationPageTemplate(
      title: "生理について",
      isOnSequenceAppearance: setting.isOnSequenceAppearance,
      pillSheetList: SettingMenstruationPillSheetList(
        pillSheetTypes: setting.pillSheetTypes,
        isOnSequenceAppearance: setting.isOnSequenceAppearance,
        selectedPillNumber: setting.pillNumberForFromMenstruation,
        onPageChanged: (number) {
          currentPage = number;
        },
        markSelected: (number) {
          analytics.logEvent(
              name: "from_menstruation_setting",
              parameters: {"number": number});
          store.modifyFromMenstruation(number);
        },
      ),
      pillSheetView: SettingPillSheetView(
        pageIndex: 0,
        isOnSequenceAppearance: setting.isOnSequenceAppearance,
        pillSheetTypes: setting.pillSheetTypes,
        selectedPillNumberIntoPillSheet: setting.pillNumberForFromMenstruation,
        markSelected: (number) {
          analytics.logEvent(
              name: "from_menstruation_initial_setting",
              parameters: {"number": number});
          store.modifyFromMenstruation(number);
        },
      ),
      dynamicDescription: SettingMenstruationDynamicDescription(
        fromMenstruation: setting.pillNumberForFromMenstruation,
        fromMenstructionDidDecide: (number) {
          analytics.logEvent(
              name: "from_menstruation_initial_setting",
              parameters: {"number": number});
          store.modifyFromMenstruation(number);
        },
        durationMenstruation: setting.durationMenstruation,
        durationMenstructionDidDecide: (number) {
          analytics.logEvent(
              name: "duration_menstruation_initial_setting",
              parameters: {"number": number});
          store.modifyDurationMenstruation(number);
        },
        retrieveFocusedPillSheetType: () {
          return setting.pillSheetTypes[currentPage];
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
