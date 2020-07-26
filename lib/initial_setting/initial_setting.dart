import 'package:Pilll/color.dart';
import 'package:Pilll/initial_setting/initial_setting_1.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef InitialSettingCallback = void Function(InitialSettingModel);

class InitialSettingModel extends ChangeNotifier {
  PillSheetType pillSheetType;
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
                style: TextStyles.title,
              ),
              Text(
                "あなたの飲んでいるピルのタイプから\n使いはじめる準備をします",
                style: TextStyles.subTitle,
              ),
              Image(
                image: AssetImage('images/initial_setting_pill_sheet.png'),
              ),
              FlatButton(
                color: PilllColors.enable,
                child: Container(
                  width: 180,
                  height: 44,
                  child: Center(
                      child: Text(
                    "OK",
                    style: TextStyles.done,
                  )),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return ChangeNotifierProvider<InitialSettingModel>(
                          create: (context) => InitialSettingModel(),
                          builder: (BuildContext context, Widget child) {
                            return InitialSetting1();
                          },
                        );
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
