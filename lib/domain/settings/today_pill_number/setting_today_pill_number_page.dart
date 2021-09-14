import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/settings/today_pill_number/setting_today_pill_number_store.dart';
import 'package:pilll/domain/settings/today_pill_number/setting_today_pill_number_pill_sheet_list.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';

class SettingTodayPillNumberPage extends HookWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet activedPillSheet;

  const SettingTodayPillNumberPage({
    Key? key,
    required this.pillSheetGroup,
    required this.activedPillSheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useProvider(settingTodayPillNumberStoreProvider.state);
    final store = useProvider(settingTodayPillNumberStoreProvider);
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "ピル番号の変更",
          style: TextStyle(color: TextColor.black),
        ),
        backgroundColor: PilllColors.white,
      ),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Stack(
              children: [
                ListView(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "今日(${_today()})\n飲む・飲んだピルの番号をタップ",
                      style: FontType.sBigTitle.merge(TextColorStyle.main),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 56),
                    Center(
                      child: SettingTodayPillNumberPillSheetList(
                        pillSheetTypes: pillSheetGroup.pillSheets
                            .map((e) => e.pillSheetType)
                            .toList(),
                        selectedPageIndex: state.selectedPillSheetPageIndex,
                        selectedTodayPillNumberIntoPillSheet:
                            state.selectedPillMarkNumberIntoPillSheet,
                        markSelected: (pageIndex, pillNumberIntoPillSheet) =>
                            store.markSelected(
                                pageIndex: pageIndex,
                                pillNumberIntoPillSheet:
                                    pillNumberIntoPillSheet),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PrimaryButton(
                        onPressed: () {
                          store.modifyBeginingDate(
                            pillSheetGroup: pillSheetGroup,
                            activedPillSheet: activedPillSheet,
                          );
                          Navigator.of(context).pop();
                        },
                        text: "変更する",
                      ),
                      SizedBox(height: 35),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _today() {
    return "${DateTimeFormatter.slashYearAndMonthAndDay(DateTime.now())}(${DateTimeFormatter.weekday(DateTime.now())})";
  }
}

extension SettingTodayPillNumberPageRoute on SettingTodayPillNumberPage {
  static Route<dynamic> route({
    required PillSheetGroup pillSheetGroup,
    required PillSheet activedPillSheet,
  }) {
    return MaterialPageRoute(
      settings: RouteSettings(name: "SettingTodayPillNumberPage"),
      builder: (_) => SettingTodayPillNumberPage(
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: activedPillSheet,
      ),
    );
  }
}
