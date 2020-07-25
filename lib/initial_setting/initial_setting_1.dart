import 'package:Pilll/color.dart';
import 'package:Pilll/initial_setting/initial_setting.dart';
import 'package:Pilll/initial_setting/pill_sheet.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InitialSetting1 extends StatefulWidget {
  final InitialSettingModel model;
  final InitialSettingCallback done;

  const InitialSetting1({Key key, this.model, this.done}) : super(key: key);

  @override
  State<StatefulWidget> createState() => InitialSetting1State();
}

class InitialSetting1State extends State<InitialSetting1> {
  PillSheetType selectedPillSheetType;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget _pillSheet(PillSheetType type) {
    return GestureDetector(
      onTap: () {
        setState(() {
          this.selectedPillSheetType = type;
        });
      },
      child: PillSheet(pillSheetType: type, selected: this.selectedPillSheetType == type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
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
                  children:
                      PillSheetType.values.map((e) => _pillSheet(e)).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
