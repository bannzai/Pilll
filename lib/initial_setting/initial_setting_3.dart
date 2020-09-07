import 'package:Pilll/main/application/router.dart';
import 'package:Pilll/main/components/setting_menstruation_page.dart';
import 'package:Pilll/model/setting.dart';
import 'package:Pilll/initial_setting/initial_setting_4.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitialSetting3 extends StatefulWidget {
  @override
  _InitialSetting3State createState() => _InitialSetting3State();
}

class _InitialSetting3State extends State<InitialSetting3> {
  @override
  Widget build(BuildContext context) {
    var model = Provider.of<Setting>(context, listen: false);
    throw SettingMenstruationPage(
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
        Provider.of<Setting>(context, listen: false)
            .register()
            .then((_) => Router.endInitialSetting(context));
      },
      selectedFromMenstruation: model.fromMenstruation,
      fromMenstructionDidDecide: (selectedFromMenstruction) {
        setState(() {
          model.fromMenstruation = selectedFromMenstruction;
          Navigator.pop(context);
        });
      },
      selectedDurationMenstruation: model.durationMenstruation,
      durationMenstructionDidDecide: (selectedDurationMenstruation) {
        setState(() {
          model.durationMenstruation = selectedDurationMenstruation;
          Navigator.pop(context);
        });
      },
    );
  }
}
