import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/settings/today_pill_number/setting_today_pill_number_pill_sheet_list.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/provider/change_pill_number.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:flutter/material.dart';
import 'package:pilll/utils/local_notification.dart';

class SettingTodayPillNumberPage extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet activePillSheet;

  const SettingTodayPillNumberPage({
    super.key,
    required this.pillSheetGroup,
    required this.activePillSheet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pillNumberInPillSheetState = useState(
      _pillNumberInPillSheet(
        activePillSheet: activePillSheet,
        pillSheetGroup: pillSheetGroup,
      ),
    );
    final pillSheetPageIndexState = useState(activePillSheet.groupIndex);
    final changePillNumber = ref.watch(changePillNumberProvider);
    final registerReminderLocalNotification = ref.watch(
      registerReminderLocalNotificationProvider,
    );
    final navigator = Navigator.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          L.changePillNumber,
          style: const TextStyle(color: TextColor.black),
        ),
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              ListView(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    L.selectTodayPillNumber(_today()),
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
                      pillSheetTypes: pillSheetGroup.pillSheets
                          .map((e) => e.pillSheetType)
                          .toList(),
                      pillSheetAppearanceMode:
                          pillSheetGroup.pillSheetAppearanceMode,
                      selectedTodayPillNumberIntoPillSheet: (pageIndex) {
                        if (pillSheetPageIndexState.value != pageIndex) {
                          return null;
                        }
                        return pillNumberInPillSheetState.value;
                      },
                      markSelected:
                          (pillSheetPageIndex, pillNumberInPillSheet) {
                            pillSheetPageIndexState.value = pillSheetPageIndex;
                            pillNumberInPillSheetState.value =
                                pillNumberInPillSheet;
                          },
                    ),
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
                            activePillSheet: activePillSheet,
                            pillSheetPageIndex: pillSheetPageIndexState.value,
                            pillNumberInPillSheet:
                                pillNumberInPillSheetState.value,
                          );
                          await registerReminderLocalNotification();

                          navigator.pop();
                        },
                        text: L.change,
                      ),
                    ),
                    const SizedBox(height: 35),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _today() {
    return DateFormat.MEd().format(today());
  }

  int _pillNumberInPillSheet({
    required PillSheet activePillSheet,
    required PillSheetGroup pillSheetGroup,
  }) {
    final pillSheetTypes = pillSheetGroup.pillSheets
        .map((e) => e.pillSheetType)
        .toList();
    final passedTotalCount = summarizedPillCountWithPillSheetTypesToIndex(
      pillSheetTypes: pillSheetTypes,
      toIndex: activePillSheet.groupIndex,
    );
    if (passedTotalCount >= activePillSheet.todayPillNumber) {
      return activePillSheet.todayPillNumber;
    }
    return activePillSheet.todayPillNumber - passedTotalCount;
  }
}

extension SettingTodayPillNumberPageRoute on SettingTodayPillNumberPage {
  static Route<dynamic> route({
    required PillSheetGroup pillSheetGroup,
    required PillSheet activePillSheet,
  }) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: 'SettingTodayPillNumberPage'),
      builder: (_) => SettingTodayPillNumberPage(
        pillSheetGroup: pillSheetGroup,
        activePillSheet: activePillSheet,
      ),
    );
  }
}
