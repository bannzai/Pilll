import 'package:pilll/analytics.dart';
import 'package:pilll/components/molecules/template/setting_menstruation/setting_menstruation.dart';
import 'package:pilll/domain/initial_setting/initial_setting_reminder_times.dart';
import 'package:pilll/domain/initial_setting/initial_setting_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class InitialSettingMenstruationPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final store = useProvider(initialSettingStoreProvider);
    final state = useProvider(initialSettingStoreProvider.state);
    return SettingMenstruationPage(
      title: "4/5",
      doneText: "次へ",
      done: () {
        analytics.logEvent(name: "done_on_initial_setting_menstruation");
        Navigator.of(context)
            .push(InitialSettingReminderTimesPageRoute.route());
      },
      pillSheetTotalCount: state.pillSheetType!.totalCount,
      model: SettingMenstruationPageModel(
        selectedFromMenstruation: state.fromMenstruation,
        selectedDurationMenstruation: state.durationMenstruation,
        pillSheetType: state.pillSheetType!,
      ),
      fromMenstructionDidDecide: (selectedFromMenstruction) {
        analytics.logEvent(name: "from_menstruation_initial_setting");
        store.setFromMenstruation(selectedFromMenstruction);
      },
      durationMenstructionDidDecide: (selectedDurationMenstruation) {
        analytics.logEvent(name: "duration_menstruation_initial_setting");
        store.setFromMenstruation(selectedDurationMenstruation);
      },
      pillSheetPageCount: state.pillSheetCount,
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
