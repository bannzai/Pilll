import 'package:pilll/analytics.dart';
import 'package:pilll/domain/initial_setting/initial_setting_2_page.dart';
import 'package:pilll/components/organisms/pill/pill_sheet_type_select_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/store/initial_setting.dart';
import 'package:flutter/material.dart';

class InitialSetting1Page extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final store = useProvider(initialSettingStoreProvider);
    final state = useProvider(initialSettingStoreProvider.state);
    return PillSheetTypeSelectPage(
      title: "1/4",
      backButtonIsHidden: true,
      selected: (type) {
        store.selectedPillSheetType(type);
      },
      done: state.entity.pillSheetType == null
          ? null
          : () {
              Navigator.of(context).push(InitialSetting2PageRoute.route());
            },
      doneButtonText: "次へ",
      selectedPillSheetType: state.entity.pillSheetType,
    );
  }
}

extension InitialSetting1PageRoute on InitialSetting1Page {
  static InitialSetting1Page screen() {
    analytics.setCurrentScreen(screenName: "InitialSetting1Page");
    return InitialSetting1Page();
  }
}
