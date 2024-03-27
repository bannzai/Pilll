import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/record/components/setting/components/appearance_mode/switching_appearance_mode.dart';
import 'package:pilll/features/record/components/setting/components/display_number_setting/display_number_setting_button.dart';
import 'package:pilll/features/record/components/setting/components/rest_duration/begin_manual_rest_duration_button.dart';
import 'package:pilll/features/record/components/setting/components/rest_duration/end_manual_rest_duration_button.dart';
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
      maxChildSize: 0.3,
      initialChildSize: 0.3,
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
                DisplayNumberSettingButton(
                  pillSheetGroup: pillSheetGroup,
                ),
              if (restDuration == null)
                GestureDetector(
                  child: const Row(children: [
                    Icon(Icons.stop_circle, color: PilllColors.primary),
                    SizedBox(width: 6),
                    Text(
                      "服用お休み開始",
                      style: TextStyle(
                        color: TextColor.main,
                        fontSize: 12,
                        fontFamily: FontFamily.japanese,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ]),
                  onTap: () {},
                )
              else
                GestureDetector(
                  child: const Row(children: [
                    Icon(Icons.stop_circle, color: PilllColors.primary),
                    SizedBox(width: 6),
                    Text(
                      "服用お休み終了",
                      style: TextStyle(
                        color: TextColor.main,
                        fontSize: 12,
                        fontFamily: FontFamily.japanese,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ]),
                  onTap: () {},
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
