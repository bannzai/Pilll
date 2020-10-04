import 'package:Pilll/main/application/router.dart';
import 'package:Pilll/model/app_state.dart';
import 'package:Pilll/model/initial_setting.dart';
import 'package:Pilll/model/setting.dart';
import 'package:Pilll/style/button.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/initial_setting/initial_setting_3.dart';
import 'package:Pilll/main/components/pill/pill_sheet.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:Pilll/util/today.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InitialSetting2 extends StatelessWidget {
  const InitialSetting2({Key key}) : super(key: key);

  String todayString() {
    return DateFormat.yMd('ja').format(today());
  }

  @override
  Widget build(BuildContext context) {
    var model = AppState.watch(context);
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
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 24),
              Text(
                "今日(${todayString()})\n飲む・飲んだピルの番号をタップ",
                style: FontType.title.merge(TextColorStyle.standard),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              PillSheet(
                isHideWeekdayLine: true,
                pillMarkTypeBuilder: (number) {
                  return model.initialSetting.pillMarkTypeFor(number);
                },
                markSelected: (number) {
                  model.notifyWith(
                      (model) => model.initialSetting.todayPillNumber = number);
                },
              ),
              SizedBox(height: 24),
              ExplainPillNumber(today: todayString()),
              SizedBox(height: 24),
              Wrap(
                direction: Axis.vertical,
                spacing: 8,
                children: <Widget>[
                  Selector<AppState, int>(
                    selector: (context, state) =>
                        state.initialSetting.todayPillNumber,
                    builder:
                        (BuildContext context, todayPillNumber, Widget child) {
                      return PrimaryButton(
                        text: "次へ",
                        onPressed: todayPillNumber == null
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
                  TertiaryButton(
                    text: "スキップ",
                    onPressed: () {
                      AppState.read(context)
                          .initialSetting
                          .register()
                          .then((_) => Router.endInitialSetting(context));
                    },
                  ),
                ],
              ),
              Spacer(),
            ],
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
    InitialSettingModel model = Provider.of(context);
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.ideographic,
        children: () {
          if (model.todayPillNumber == null) {
            return <Widget>[
              Text("", style: FontType.largeNumber.merge(TextColorStyle.black)),
            ];
          }
          return <Widget>[
            Text("$todayに飲むピルは",
                style: FontType.description.merge(TextColorStyle.black)),
            Text("${model.todayPillNumber}",
                style: FontType.largeNumber.merge(TextColorStyle.black)),
            Text("番", style: FontType.description.merge(TextColorStyle.black)),
          ];
        }(),
      ),
    );
  }
}
