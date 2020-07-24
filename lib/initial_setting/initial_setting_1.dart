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
              _pillSheet21(),
              _pillSheet28_4(),
              _pillSheet28_7()
            ],
          ),
        ),
      ),
    );
  }

  Container _pillSheet28_7() {
    return Container(
      width: 295,
      height: 143,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: PilllColors.plainText),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.check, color: PilllColors.disable, size: 13),
                  SizedBox(width: 8),
                  Text("28錠タイプ(7錠偽薬)", style: TextStyles.subTitle),
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SvgPicture.asset("images/pillsheet_28_7.svg"),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("・トリキュラー28", style: TextStyles.list),
                      Text("・マーベロン28", style: TextStyles.list),
                      Text("・アンジュ28", style: TextStyles.list),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _pillSheet28_4() {
    return Container(
      width: 295,
      height: 143,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: PilllColors.plainText),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.check, color: PilllColors.disable, size: 13),
                  SizedBox(width: 8),
                  Text("28錠タイプ(4錠偽薬)", style: TextStyles.subTitle),
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SvgPicture.asset("images/pillsheet_28_4.svg"),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("・ヤーズなど", style: TextStyles.list),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _pillSheet21() {
    return Container(
      width: 295,
      height: 143,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: PilllColors.plainText),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.check, color: PilllColors.disable, size: 13),
                  SizedBox(width: 8),
                  Text("21錠タイプ", style: TextStyles.subTitle),
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SvgPicture.asset("images/pillsheet_21.svg"),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
        ],
      ),
    );
  }
}
