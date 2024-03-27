import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/features/record/components/setting/components/appearance_mode/switching_appearance_mode.dart';
import 'package:pilll/features/record/components/setting/components/delete/pill_sheet_group_delete.dart';
import 'package:pilll/features/record/components/setting/components/display_number_setting/display_number_setting.dart';
import 'package:pilll/features/record/components/setting/components/rest_duration/begin_manual_rest_duration.dart';
import 'package:pilll/features/record/components/setting/components/rest_duration/end_manual_rest_duration.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/record/components/setting/components/today_number/today_pill_number.dart';
import 'package:pilll/provider/delete_pill_sheet.dart';
import 'package:pilll/utils/local_notification.dart';

class PillSheetSettingSheet extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet activePillSheet;
  final Setting setting;
  final User user;

  const PillSheetSettingSheet({
    Key? key,
    required this.pillSheetGroup,
    required this.activePillSheet,
    required this.setting,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RestDuration? restDuration = activePillSheet.activeRestDuration;
    final themeData = Theme.of(context);
    final deletePillSheetGroup = ref.watch(deletePillSheetGroupProvider);
    final cancelReminderLocalNotification = ref.watch(cancelReminderLocalNotificationProvider);

    Future<void> onDelete(PillSheetGroup pillSheetGroup, PillSheet activePillSheet) async {
      try {
        await deletePillSheetGroup(latestPillSheetGroup: pillSheetGroup, activePillSheet: activePillSheet);
        await cancelReminderLocalNotification();
        if (context.mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("ピルシートを破棄しました"),
            ),
          );
        }
      } catch (error) {
        if (context.mounted) {
          showErrorAlert(context, error);
        }
      }
    }

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
      child: DraggableScrollableSheet(
        builder: (context, scrollController) {
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                TodayPillNumber(
                  pillSheetGroup: pillSheetGroup,
                  activePillSheet: activePillSheet,
                ),
                SwitchingAppearanceMode(
                  setting: setting,
                  user: user,
                ),
                if (setting.pillSheetAppearanceMode == PillSheetAppearanceMode.sequential)
                  DisplayNumberSetting(
                    pillSheetGroup: pillSheetGroup,
                  ),
                if (restDuration == null)
                  BeginManualRestDuration(
                    appearanceMode: setting.pillSheetAppearanceMode,
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
                PillSheetGroupDelete(
                  pillSheetGroup: pillSheetGroup,
                  activePillSheet: activePillSheet,
                  onDelete: onDelete,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

void showPillSheetSettingSheet(BuildContext context, PillSheetSettingSheet sheet) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => sheet,
  );
}
