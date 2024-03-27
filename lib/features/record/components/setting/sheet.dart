import 'package:flutter/material.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/record/components/setting/components/appearance_mode/switching_appearance_mode.dart';
import 'package:pilll/features/record/components/setting/components/display_number_setting/display_number_setting_sheet.dart';
import 'package:pilll/features/record/components/setting/components/rest_duration/begin_manual_rest_duration.dart';
import 'package:pilll/features/record/components/setting/components/rest_duration/end_manual_rest_duration.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';

class PillSheetSettingSheet extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final RestDuration? restDuration = activePillSheet.activeRestDuration;

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          color: Colors.white,
          child: Column(
            children: [
              SwitchingAppearanceMode(
                setting: setting,
                user: user,
              ),
              if (setting.pillSheetAppearanceMode == PillSheetAppearanceMode.sequential)
                DisplayNumberSettingSheet(
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
            ],
          ),
        );
      },
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
