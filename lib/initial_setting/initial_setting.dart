import 'package:Pilll/color.dart';
import 'package:Pilll/initial_setting/initial_setting_1.dart';
import 'package:Pilll/text_style.dart';
import 'package:flutter/material.dart';

typedef InitialSettingCallback = void Function(InitialSettingModel);

class InitialSettingModel {}

class InitialSetting extends StatelessWidget {
  final InitialSettingModel model;
  final InitialSettingCallback done;

  const InitialSetting({Key key, this.done, this.model}) : super(key: key);
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
                color: PilllColors.strong,
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
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return InitialSetting1(model: model, done: done);
                  }));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
