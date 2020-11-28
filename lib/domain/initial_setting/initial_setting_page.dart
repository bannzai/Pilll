import 'package:Pilll/components/atoms/buttons.dart';
import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/domain/initial_setting/initial_setting_1_page.dart';
import 'package:Pilll/components/atoms/font.dart';
import 'package:Pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';

class InitialSettingPage extends StatelessWidget {
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
              PrimaryButton(
                text: "OK",
                onPressed: () {
                  Navigator.of(context).push(InitialSetting1PageRoute.route());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
