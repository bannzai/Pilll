import 'package:Pilll/main/application/router.dart';
import 'package:Pilll/main/components/setting_menstruation_page.dart';
import 'package:Pilll/initial_setting/initial_setting_4.dart';
import 'package:Pilll/model/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InitialSetting3 extends StatefulWidget {
  @override
  _InitialSetting3State createState() => _InitialSetting3State();
}

class _InitialSetting3State extends State<InitialSetting3> {
  @override
  Widget build(BuildContext context) {
    var model = AppState.watch(context);
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
        model.initialSetting
            .register()
            .then((_) => Router.endInitialSetting(context));
      },
      model: SettingMenstruationPageModel(
        selectedFromMenstruation: model.initialSetting.fromMenstruation,
        selectedDurationMenstruation: model.initialSetting.durationMenstruation,
      ),
      fromMenstructionDidDecide: (selectedFromMenstruction) {
        setState(() {
          model.initialSetting.fromMenstruation = selectedFromMenstruction;
        });
      },
      durationMenstructionDidDecide: (selectedDurationMenstruation) {
        setState(() {
          model.initialSetting.durationMenstruation =
              selectedDurationMenstruation;
        });
      },
    );
  }
}
