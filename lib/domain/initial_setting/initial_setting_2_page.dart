import 'package:Pilll/store/initial_setting.dart';
import 'package:Pilll/components/atoms/buttons.dart';
import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/domain/initial_setting/initial_setting_3_page.dart';
import 'package:Pilll/components/organisms/pill/pill_sheet.dart';
import 'package:Pilll/components/atoms/font.dart';
import 'package:Pilll/components/atoms/text_color.dart';
import 'package:Pilll/util/datetime/day.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:intl/intl.dart';

class InitialSetting2Page extends HookWidget {
  const InitialSetting2Page({Key key}) : super(key: key);

  String todayString() {
    return DateFormat.yMEd('ja').format(today());
  }

  @override
  Widget build(BuildContext context) {
    final store = useProvider(initialSettingStoreProvider);
    final state = useProvider(initialSettingStoreProvider.state);
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
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: [
                      SizedBox(height: 24),
                      Text(
                        "今日(${todayString()})\n飲む・飲んだピルの番号をタップ",
                        style: FontType.sBigTitle.merge(TextColorStyle.main),
                        textAlign: TextAlign.center,
                      ),
                      Spacer(),
                      PillSheet(
                        pillMarkTypeBuilder: (number) {
                          return state.entity.pillMarkTypeFor(number);
                        },
                        doneStateBuilder: (number) {
                          return false;
                        },
                        enabledMarkAnimation: null,
                        markSelected: (number) {
                          store.modify((model) =>
                              model.copyWith(todayPillNumber: number));
                        },
                      ),
                      SizedBox(height: 24),
                      ExplainPillNumber(today: todayString()),
                      SizedBox(height: 16),
                      InconspicuousButton(
                        onPressed: () {
                          store.modify(
                              (model) => model.copyWith(todayPillNumber: null));
                          Navigator.of(context)
                              .push(InitialSetting3PageRoute.route());
                        },
                        text: "まだ分からない",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: PrimaryButton(
                    text: "次へ",
                    onPressed: state.entity.todayPillNumber == null
                        ? null
                        : () {
                            Navigator.of(context)
                                .push(InitialSetting3PageRoute.route());
                          },
                  ),
                ),
                SizedBox(height: 35),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExplainPillNumber extends HookWidget {
  final String today;

  const ExplainPillNumber({Key key, this.today}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final state = useProvider(initialSettingStoreProvider.state);
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.ideographic,
        children: () {
          if (state.entity.todayPillNumber == null) {
            return <Widget>[
              Text("", style: FontType.largeNumber.merge(TextColorStyle.main)),
            ];
          }
          return <Widget>[
            Text("$todayに飲むピルは",
                style: FontType.description.merge(TextColorStyle.main)),
            Text("${state.entity.todayPillNumber}",
                style: FontType.largeNumber.merge(TextColorStyle.main)),
            Text("番", style: FontType.description.merge(TextColorStyle.main)),
          ];
        }(),
      ),
    );
  }
}

extension InitialSetting2PageRoute on InitialSetting2Page {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: "InitialSetting2Page"),
      builder: (_) => InitialSetting2Page(),
    );
  }
}
