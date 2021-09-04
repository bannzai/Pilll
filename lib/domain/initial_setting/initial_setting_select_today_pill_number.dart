import 'package:pilll/analytics.dart';
import 'package:pilll/components/organisms/pill/setting_pill_sheet_view.dart';
import 'package:pilll/domain/initial_setting/initial_setting_store.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/domain/initial_setting/initial_setting_menstruation.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class InitialSettingSelectTodayPillNumberPage extends HookWidget {
  const InitialSettingSelectTodayPillNumberPage({Key? key}) : super(key: key);

  String todayString() {
    return DateFormat.yMEd('ja').format(today());
  }

  @override
  Widget build(BuildContext context) {
    final store = useProvider(initialSettingStoreProvider);
    final state = useProvider(initialSettingStoreProvider.state);
    final pillSheetType = state.pillSheetType;
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
        backgroundColor: PilllColors.white,
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
                      SizedBox(height: 44),
                      if (pillSheetType != null)
                        Align(
                          child: SettingPillSheetView(
                            pillSheetType: pillSheetType,
                            selectedPillNumber: state.todayPillNumber,
                            markSelected: (number) {
                              analytics.logEvent(
                                  name: "selected_today_number_initial_setting",
                                  parameters: {"pill_number": number});
                              store.setTodayPillNumber(number);
                            },
                          ),
                        ),
                      SizedBox(height: 24),
                      ExplainPillNumber(today: todayString()),
                      SizedBox(height: 16),
                      InconspicuousButton(
                        onPressed: () {
                          store.unsetTodayPillNumber();
                          analytics.logEvent(
                              name: "unknown_number_initial_setting");
                          Navigator.of(context).push(
                              InitialSettingMenstruationPageRoute.route());
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
                    onPressed: state.todayPillNumber == null
                        ? null
                        : () {
                            analytics.logEvent(
                                name: "done_today_number_initial_setting");
                            Navigator.of(context).push(
                                InitialSettingMenstruationPageRoute.route());
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

  const ExplainPillNumber({Key? key, required this.today}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final state = useProvider(initialSettingStoreProvider.state);
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.ideographic,
        children: () {
          if (state.todayPillNumber == null) {
            return <Widget>[
              Text("", style: FontType.largeNumber.merge(TextColorStyle.main)),
            ];
          }
          return <Widget>[
            Text("$todayに飲むピルは",
                style: FontType.description.merge(TextColorStyle.main)),
            Text("${state.todayPillNumber}",
                style: FontType.largeNumber.merge(TextColorStyle.main)),
            Text("番", style: FontType.description.merge(TextColorStyle.main)),
          ];
        }(),
      ),
    );
  }
}

extension InitialSettingSelectTodayPillNumberPageRoute
    on InitialSettingSelectTodayPillNumberPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: "InitialSettingSelectTodayPillNumberPage"),
      builder: (_) => InitialSettingSelectTodayPillNumberPage(),
    );
  }
}
