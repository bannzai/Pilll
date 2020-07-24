import 'package:Pilll/color.dart';
import 'package:Pilll/font.dart';
import 'package:Pilll/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InitialSetting1 extends StatelessWidget {
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
              Text("飲んでいるピルのタイプはどれ？", style: TextStyles.title),
              Container(
                width: 295,
                height: 143,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: PilllColors.plainText),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.check, color: PilllColors.disable, size: 13),
                        SizedBox(width: 8),
                        Text("21錠タイプ", style: TextStyles.subTitle),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset("images/pillsheet_21.svg"),
                        Column(
                          children: <Widget>[
                            Text("・トリキュラー21", style: TextStyles.list),
                            Text("・トリキュラー21", style: TextStyles.list),
                            Text("・トリキュラー21", style: TextStyles.list),
                            Text("・トリキュラー21", style: TextStyles.list),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
