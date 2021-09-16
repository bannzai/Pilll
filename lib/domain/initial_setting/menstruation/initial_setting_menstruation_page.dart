import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/template/setting_menstruation/setting_menstruation_dynamic_description.dart';
import 'package:pilll/components/template/setting_menstruation/setting_menstruation_page_template.dart';
import 'package:pilll/components/template/setting_menstruation/setting_menstruation_pill_sheet_list.dart';
import 'package:pilll/domain/initial_setting/reminder_times/initial_setting_reminder_times_page.dart';
import 'package:pilll/domain/initial_setting/initial_setting_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InitialSettingMenstruationPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final store = useProvider(initialSettingStoreProvider);
    final state = useProvider(initialSettingStoreProvider.state);

    return SettingMenstruationPageTemplate(
      title: "4/5",
      pillSheetList: SettingMenstruationPillSheetList(
        pillSheetTypes: state.pillSheetTypes,
        selectedPillSheetPageIndex: state.currentMenstruationPageIndex,
        selectedPillNumber: (pageIndex) =>
            store.retrieveMenstruationSelectedPillNumber(pageIndex),
        onPageChanged: (pageIndex) {
          store.setCurrentMenstruationPageIndex(pageIndex);
        },
        markSelected: (pageIndex, number) {
          analytics.logEvent(
              name: "from_menstruation_initial_setting",
              parameters: {"number": number, "page": pageIndex});
          store.setFromMenstruation(
              pageIndex: pageIndex, fromMenstruation: number);
        },
      ),
      doneButton: PrimaryButton(
        onPressed: () {
          analytics.logEvent(name: "done_on_initial_setting_menstruation");
          Navigator.of(context)
              .push(InitialSettingReminderTimesPageRoute.route());
        },
        text: "次へ",
      ),
      dynamicDescription: SettingMenstruationDynamicDescription(
        fromMenstruation: state.fromMenstruation,
        fromMenstructionDidDecide: (number) {
          analytics.logEvent(
              name: "from_menstruation_initial_setting",
              parameters: {"number": number});
          store.setFromMenstruation(
            pageIndex: state.currentMenstruationPageIndex,
            fromMenstruation: number,
          );
        },
        durationMenstruation: state.durationMenstruation,
        durationMenstructionDidDecide: (number) {
          analytics.logEvent(
              name: "duration_menstruation_initial_setting",
              parameters: {
                "number": number,
                "page": state.currentMenstruationPageIndex
              });
          store.setDurationMenstruation(durationMenstruation: number);
        },
        retrieveFocusedPillSheetType: () {
          return state.pillSheetTypes[state.currentMenstruationPageIndex];
        },
      ),
    );
  }
}

extension InitialSettingMenstruationPageRoute
    on InitialSettingMenstruationPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: "InitialSettingMenstruationPage"),
      builder: (_) => InitialSettingMenstruationPage(),
    );
  }
}
