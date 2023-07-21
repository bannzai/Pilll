import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/settings/today_pill_number/setting_today_pill_number_pill_sheet_list.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/change_pill_number.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:pilll/utils/local_notification.dart';

class SettingTodayPillNumberPage extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet activedPillSheet;

  const SettingTodayPillNumberPage({
    Key? key,
    required this.pillSheetGroup,
    required this.activedPillSheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pillNumberIntoPillSheetState = useState(_pillNumberIntoPillSheet(activedPillSheet: activedPillSheet, pillSheetGroup: pillSheetGroup));
    final pillSheetPageIndexState = useState(activedPillSheet.groupIndex);
    final changePillNumber = ref.watch(changePillNumberProvider);
    final registerReminderLocalNotification = ref.watch(registerReminderLocalNotificationProvider);
    final navigator = Navigator.of(context);

    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "ピル番号の変更",
          style: TextStyle(color: TextColor.black),
        ),
        backgroundColor: PilllColors.white,
      ),
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              ListView(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "今日(${_today()})\n飲む・飲んだピルの番号をタップ",
                    style: const TextStyle(
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: TextColor.main,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 56),
                  Center(
                    child: SettingTodayPillNumberPillSheetList(
                        pillSheetTypes: pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList(),
                        appearanceMode: PillSheetAppearanceMode.number,
                        selectedTodayPillNumberIntoPillSheet: (pageIndex) {
                          if (pillSheetPageIndexState.value != pageIndex) {
                            return null;
                          }
                          return pillNumberIntoPillSheetState.value;
                        },
                        markSelected: (pillSheetPageIndex, pillNumberIntoPillSheet) {
                          pillSheetPageIndexState.value = pillSheetPageIndex;
                          pillNumberIntoPillSheetState.value = pillNumberIntoPillSheet;
                        }),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 180,
                      child: PrimaryButton(
                        onPressed: () async {
                          await changePillNumber(
                              pillSheetGroup: pillSheetGroup,
                              activedPillSheet: activedPillSheet,
                              pillSheetPageIndex: pillSheetPageIndexState.value,
                              pillNumberIntoPillSheet: pillNumberIntoPillSheetState.value);
                          await registerReminderLocalNotification();

                          navigator.pop();
                        },
                        text: "変更する",
                      ),
                    ),
                    const SizedBox(height: 35),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _today() {
    return "${DateTimeFormatter.slashYearAndMonthAndDay(DateTime.now())}(${DateTimeFormatter.weekday(DateTime.now())})";
  }

  int _pillNumberIntoPillSheet({
    required PillSheet activedPillSheet,
    required PillSheetGroup pillSheetGroup,
  }) {
    final pillSheetTypes = pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList();
    final passedTotalCount = summarizedPillCountWithPillSheetTypesToIndex(pillSheetTypes: pillSheetTypes, toIndex: activedPillSheet.groupIndex);
    if (passedTotalCount >= activedPillSheet.todayPillNumber) {
      return activedPillSheet.todayPillNumber;
    }
    return activedPillSheet.todayPillNumber - passedTotalCount;
  }
}

extension SettingTodayPillNumberPageRoute on SettingTodayPillNumberPage {
  static Route<dynamic> route({
    required PillSheetGroup pillSheetGroup,
    required PillSheet activedPillSheet,
  }) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: "SettingTodayPillNumberPage"),
      builder: (_) => SettingTodayPillNumberPage(
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: activedPillSheet,
      ),
    );
  }
}
