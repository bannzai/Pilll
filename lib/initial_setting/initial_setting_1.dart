import 'package:Pilll/initial_setting/initial_setting_2.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/initial_setting/initial_setting.dart';
import 'package:Pilll/initial_setting/pill_sheet.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitialSetting1 extends StatefulWidget {
  const InitialSetting1({Key key}) : super(key: key);

  @override
  _InitialSetting1State createState() => _InitialSetting1State();
}

class _InitialSetting1State extends State<InitialSetting1> {
  Widget _pillSheet(PillSheetType type) {
    return Consumer<InitialSettingModel>(
      builder: (BuildContext context, InitialSettingModel value, Widget child) {
        return GestureDetector(
          onTap: () {
            setState(() {
              value.pillSheetType = type;
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return InitialSetting2();
              }));
            });
          },
          child: PillSheet(
            pillSheetType: type,
            selected:
                context.watch<InitialSettingModel>().pillSheetType == type,
          ),
        );
      },
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
          "1/4",
          style: TextStyle(color: TextColor.black),
        ),
        backgroundColor: PilllColors.background,
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 24),
              Text("飲んでいるピルのタイプはどれ？",
                  style: FontType.title.merge(TextColorStyle.standard)),
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
