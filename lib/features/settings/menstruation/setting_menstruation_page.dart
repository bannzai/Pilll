import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/template/setting_menstruation/setting_menstruation_dynamic_description.dart';
import 'package:pilll/components/template/setting_menstruation/setting_menstruation_page_template.dart';
import 'package:pilll/components/template/setting_menstruation/setting_menstruation_pill_sheet_list.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/setting.dart';

class SettingMenstruationPage extends HookConsumerWidget {
  const SettingMenstruationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(settingProvider).requireValue;
    final setSetting = ref.watch(setSettingProvider);

    return SettingMenstruationPageTemplate(
      title: "生理について",
      pillSheetList: SettingMenstruationPillSheetList(
        pillSheetTypeInfos: setting.pillSheetEnumTypes,
        appearanceMode: PillSheetAppearanceMode.sequential,
        selectedPillNumber: (pageIndex) {
          final passedTotalCount = summarizedPillCountWithPillSheetTypesToIndex(pillSheetTypeInfos: setting.pillSheetEnumTypes, toIndex: pageIndex);
          if (passedTotalCount >= setting.pillNumberForFromMenstruation) {
            return setting.pillNumberForFromMenstruation;
          }
          final diff = setting.pillNumberForFromMenstruation - passedTotalCount;
          if (diff > setting.pillSheetEnumTypes[pageIndex].totalCount) {
            return null;
          }
          return diff;
        },
        markSelected: (pageIndex, fromMenstruation) async {
          analytics.logEvent(name: "from_menstruation_setting", parameters: {
            "number": fromMenstruation,
            "page": pageIndex,
          });
          final offset = summarizedPillCountWithPillSheetTypesToIndex(pillSheetTypeInfos: setting.pillSheetEnumTypes, toIndex: pageIndex);
          final updated = setting.copyWith(pillNumberForFromMenstruation: fromMenstruation + offset);
          await setSetting(updated);
        },
      ),
      dynamicDescription: SettingMenstruationDynamicDescription(
        pillSheetTypeInfos: setting.pillSheetEnumTypes,
        fromMenstruation: setting.pillNumberForFromMenstruation,
        fromMenstructionDidDecide: (serializedPillNumberIntoGroup) async {
          analytics.logEvent(name: "from_menstruation_initial_setting", parameters: {"number": serializedPillNumberIntoGroup});
          final updated = setting.copyWith(pillNumberForFromMenstruation: serializedPillNumberIntoGroup);
          await setSetting(updated);
        },
        durationMenstruation: setting.durationMenstruation,
        durationMenstructionDidDecide: (durationMenstruation) {
          analytics.logEvent(name: "duration_menstruation_initial_setting", parameters: {"number": durationMenstruation});
          final updated = setting.copyWith(durationMenstruation: durationMenstruation);
          setSetting(updated);
        },
      ),
      doneButton: null,
    );
  }
}

extension SettingMenstruationPageRoute on SettingMenstruationPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: "SettingMenstruationPage"),
      builder: (_) => const SettingMenstruationPage(),
    );
  }
}
