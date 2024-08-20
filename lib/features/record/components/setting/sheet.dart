import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/record/components/setting/components/appearance_mode/switching_appearance_mode.dart';
import 'package:pilll/features/record/components/setting/components/delete/pill_sheet_group_delete.dart';
import 'package:pilll/features/record/components/setting/components/display_number_setting/display_number_setting.dart';
import 'package:pilll/features/record/components/setting/components/rest_duration/begin_manual_rest_duration.dart';
import 'package:pilll/features/record/components/setting/components/rest_duration/change_manual_rest_duration.dart';
import 'package:pilll/features/record/components/setting/components/rest_duration/end_manual_rest_duration.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/record/components/setting/components/today_number/today_pill_number.dart';

class PillSheetSettingSheet extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet activePillSheet;
  final Setting setting;
  final User user;

  const PillSheetSettingSheet({
    super.key,
    required this.pillSheetGroup,
    required this.activePillSheet,
    required this.setting,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RestDuration? restDuration = pillSheetGroup.lastActiveRestDuration;
    final themeData = Theme.of(context);

    return Theme(
      data: themeData.copyWith(
        listTileTheme: themeData.listTileTheme.copyWith(
          iconColor: PilllColors.primary,
          titleTextStyle: const TextStyle(
            color: TextColor.main,
            fontSize: 14,
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TodayPillNumber(
              pillSheetGroup: pillSheetGroup,
              activePillSheet: activePillSheet,
            ),
            SwitchingAppearanceMode(
              setting: setting,
              user: user,
              pillSheetGroup: pillSheetGroup,
            ),
            if (pillSheetGroup.pillSheetAppearanceMode == PillSheetAppearanceMode.sequential)
              DisplayNumberSetting(
                pillSheetGroup: pillSheetGroup,
              ),
            if (restDuration == null)
              BeginManualRestDuration(
                appearanceMode: pillSheetGroup.pillSheetAppearanceMode,
                activePillSheet: activePillSheet,
                pillSheetGroup: pillSheetGroup,
              )
            else
              EndManualRestDuration(
                restDuration: restDuration,
                activePillSheet: activePillSheet,
                pillSheetGroup: pillSheetGroup,
                setting: setting,
              ),
            for (final restDuration in pillSheetGroup.restDurations)
              ChangeManualRestDuration(
                restDuration: restDuration,
                pillSheetGroup: pillSheetGroup,
              ),
            PillSheetGroupDelete(
              pillSheetGroup: pillSheetGroup,
              activePillSheet: activePillSheet,
            ),
          ],
        ),
      ),
    );
  }
}

void showPillSheetSettingSheet(BuildContext context, PillSheetSettingSheet sheet) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => sheet,
  );
}
