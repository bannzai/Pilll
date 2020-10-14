import 'package:Pilll/main/application/router.dart';
import 'package:Pilll/main/components/setting_menstruation_page.dart';
import 'package:Pilll/initial_setting/initial_setting_4.dart';
import 'package:Pilll/store/initial_setting.dart';
import 'package:Pilll/store/setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';

class InitialSetting3 extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final store = useProvider(initialSettingStoreProvider);
    final settingStore = useProvider(settingStoreProvider);
    final state = useProvider(initialSettingStoreProvider.state);
    return SettingMenstruationPage(
      title: "3/4",
      doneText: "次へ",
      done: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return InitialSetting4();
            },
          ),
        );
      },
      skip: () {
        settingStore.register(state.entity);
      },
      model: SettingMenstruationPageModel(
        selectedFromMenstruation: state.entity.fromMenstruation,
        selectedDurationMenstruation: state.entity.durationMenstruation,
      ),
      fromMenstructionDidDecide: (selectedFromMenstruction) {
        store.modify((model) =>
            model..copyWith(fromMenstruation: selectedFromMenstruction));
      },
      durationMenstructionDidDecide: (selectedDurationMenstruation) {
        store.modify((model) => model
          ..copyWith(durationMenstruation: selectedDurationMenstruation));
      },
    );
  }
}
