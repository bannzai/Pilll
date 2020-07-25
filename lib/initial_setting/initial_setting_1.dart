import 'package:Pilll/color.dart';
import 'package:Pilll/initial_setting/initial_setting.dart';
import 'package:Pilll/initial_setting/pill_sheet.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InitialSetting1 extends StatelessWidget {
  final InitialSettingModel model;

  const InitialSetting1({Key key, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
          title: Text(
            "1/5",
            style: TextStyle(color: PilllColors.blackText),
          ),
          backgroundColor: PilllColors.background),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 24),
              Text("飲んでいるピルのタイプはどれ？", style: TextStyles.title),
              SizedBox(height: 24),
              Container(
                height: 461,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    PillSheet(pillSheetType: PillSheetType.pillsheet_21),
                    PillSheet(pillSheetType: PillSheetType.pillsheet_28_4),
                    PillSheet(pillSheetType: PillSheetType.pillsheet_28_7),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
