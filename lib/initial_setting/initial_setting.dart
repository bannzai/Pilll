import 'package:Pilll/theme/color.dart';
import 'package:Pilll/initial_setting/initial_setting_1.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:Pilll/util/shared_preference/keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialSettingModel extends ChangeNotifier {
  PillSheetType pillSheetType;
  int fromMenstruation;
  int durationMenstruation;
  int hour;
  int minute;

  void done() {
    SharedPreferences.getInstance().then((storage) {
      storage.setBool(BoolKey.didEndInitialSetting, true);
      notifyListeners();
    });
  }
}

class InitialSetting extends StatelessWidget {
  const InitialSetting({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        backgroundColor: PilllColors.background,
        elevation: 0.0,
      ),
      body: Container(
        height: 445,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(height: 20),
              Text(
                "ピルシートをご準備ください",
                style: FontType.title.merge(TextColorStyle.black),
              ),
              Text(
                "あなたの飲んでいるピルのタイプから\n使いはじめる準備をします",
                style: FontType.thinTitle.merge(TextColorStyle.gray),
              ),
              Image(
                image: AssetImage('images/initial_setting_pill_sheet.png'),
              ),
              RaisedButton(
                child: Text(
                  "OK",
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return InitialSetting1();
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
