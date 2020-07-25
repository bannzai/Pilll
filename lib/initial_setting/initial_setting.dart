import 'package:Pilll/color.dart';
import 'package:Pilll/text_style.dart';
import 'package:flutter/material.dart';

class InitialSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        title: Text(
          "1/5",
          style: TextStyle(color: PilllColors.blackText),
        ),
        backgroundColor: PilllColors.background,
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
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
