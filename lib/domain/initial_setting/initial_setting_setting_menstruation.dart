import 'package:pilll/analytics.dart';
import 'package:pilll/components/organisms/setting/setting_menstruation_page.dart';
import 'package:pilll/domain/initial_setting/initial_setting_reminder_times.dart';
import 'package:pilll/store/initial_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class InitialSettingSettingMenstruationPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final store = useProvider(initialSettingStoreProvider);
    final state = useProvider(initialSettingStoreProvider.state);
    return SettingMenstruationPage(
      title: "3/4",
      doneText: "次へ",
      done: () {
        analytics.logEvent(name: "done_initial_setting_3");
        Navigator.of(context)
            .push(InitialSettingReminderTimesPageRoute.route());
      },
      pillSheetTotalCount: state.entity.pillSheetType!.totalCount,
      model: SettingMenstruationPageModel(
        selectedFromMenstruation: state.entity.fromMenstruation,
        selectedDurationMenstruation: state.entity.durationMenstruation,
        pillSheetType: state.entity.pillSheetType!,
      ),
      fromMenstructionDidDecide: (selectedFromMenstruction) {
        analytics.logEvent(name: "decided_from_initial_setting_3");
        store.modify((model) =>
            model.copyWith(fromMenstruation: selectedFromMenstruction));
      },
      durationMenstructionDidDecide: (selectedDurationMenstruation) {
        analytics.logEvent(name: "decided_duration_initial_setting_3");
        store.modify((model) =>
            model.copyWith(durationMenstruation: selectedDurationMenstruation));
      },
    );
  }
}

extension InitialSettingSettingMenstruationPageRoute
    on InitialSettingSettingMenstruationPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: "InitialSettingSettingMenstruationPage"),
      builder: (_) => InitialSettingSettingMenstruationPage(),
    );
  }
}
