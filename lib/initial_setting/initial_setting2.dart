import 'package:Pilll/color.dart';
import 'package:Pilll/record/pill_sheet.dart';
import 'package:Pilll/record/pill_sheet_model.dart';
import 'package:Pilll/text_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'initial_setting.dart';

class InitialSetting2 extends StatelessWidget {
  final InitialSettingModel model;
  final InitialSettingCallback done;

  const InitialSetting2({Key key, this.model, this.done}) : super(key: key);

  String today() {
    return DateFormat.yMd('ja').format(DateTime.now());
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
          "2/4",
          style: TextStyle(color: PilllColors.blackText),
        ),
        backgroundColor: PilllColors.background,
      ),
      body: ChangeNotifierProvider<PillSheetModel>(
        create: (context) => InitialSettingPillSheetModel(model.pillSheetType),
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 24),
                Text(
                  "今日(${today()})\n飲む・飲んだピルの番号をタップ",
                  style: TextStyles.title,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                PillSheet(),
                SizedBox(height: 24),
                ExplainPillNumber(today: today()),
                SizedBox(height: 24),
                Consumer<PillSheetModel>(
                  builder: (BuildContext context, model, Widget child) {
                    return FlatButton(
                      color: context.watch<PillSheetModel>().number == null
                          ? PilllColors.disable
                          : PilllColors.enable,
                      child: Container(
                        width: 180,
                        height: 44,
                        child: Center(
                            child: Text(
                          "次へ",
                          style: TextStyles.done,
                        )),
                      ),
                      onPressed: () {},
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExplainPillNumber extends StatelessWidget {
  final String today;

  const ExplainPillNumber({Key key, this.today}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    PillSheetModel model = Provider.of<PillSheetModel>(context);
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.ideographic,
        children: () {
          if (model.number == null) {
            return <Widget>[
              Text("", style: TextStyles.largeNumber),
            ];
          }
          return <Widget>[
            Text("$todayに飲むピルは", style: TextStyles.description),
            Text("${model.number}", style: TextStyles.largeNumber),
            Text("番", style: TextStyles.description),
          ];
        }(),
      ),
    );
  }
}
