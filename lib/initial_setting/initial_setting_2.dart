import 'package:Pilll/main/application/router.dart';
import 'package:Pilll/model/auth_user.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/initial_setting/initial_setting_3.dart';
import 'package:Pilll/main/record/pill_sheet.dart';
import 'package:Pilll/main/record/pill_sheet_model.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'initial_setting.dart';

class InitialSetting2 extends StatelessWidget {
  const InitialSetting2({Key key}) : super(key: key);

  String today() {
    return DateFormat.yMd('ja').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    InitialSettingModel model = context.watch();
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "2/4",
          style: TextStyle(color: TextColor.black),
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
                  style: FontType.title.merge(TextColorStyle.standard),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                PillSheet(),
                SizedBox(height: 24),
                ExplainPillNumber(today: today()),
                SizedBox(height: 24),
                Wrap(
                  direction: Axis.vertical,
                  spacing: 8,
                  children: <Widget>[
                    Consumer<PillSheetModel>(
                      builder: (BuildContext context, model, Widget child) {
                        return RaisedButton(
                          child: Text(
                            "次へ",
                          ),
                          onPressed:
                              context.watch<PillSheetModel>().number == null
                                  ? null
                                  : () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return InitialSetting3();
                                          },
                                        ),
                                      );
                                    },
                        );
                      },
                    ),
                    FlatButton(
                      child: Text("スキップ"),
                      textColor: TextColor.gray,
                      onPressed: () {
                        context.watch<InitialSettingModel>().register(
                              Provider.of<AuthUser>(context).userCredential,
                              context,
                            );
                      },
                    ),
                  ],
                ),
                Spacer(),
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
              Text("", style: FontType.largeNumber.merge(TextColorStyle.black)),
            ];
          }
          return <Widget>[
            Text("$todayに飲むピルは",
                style: FontType.description.merge(TextColorStyle.black)),
            Text("${model.number}",
                style: FontType.largeNumber.merge(TextColorStyle.black)),
            Text("番", style: FontType.description.merge(TextColorStyle.black)),
          ];
        }(),
      ),
    );
  }
}
