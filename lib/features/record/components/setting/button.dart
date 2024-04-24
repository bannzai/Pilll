import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/record/components/setting/sheet.dart';
import 'package:pilll/utils/analytics.dart';

class RecordPagePillSheetSettingButton extends StatelessWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet activePillSheet;
  final Setting setting;
  final User user;

  const RecordPagePillSheetSettingButton({
    Key? key,
    required this.pillSheetGroup,
    required this.activePillSheet,
    required this.setting,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        analytics.logEvent(name: "did_tapped_record_page_setting");
        showPillSheetSettingSheet(
          context,
          PillSheetSettingSheet(
            pillSheetGroup: pillSheetGroup,
            activePillSheet: activePillSheet,
            setting: setting,
            user: user,
          ),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(TextColor.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(
              color: PilllColors.primary,
              width: 1,
            ),
          ),
        ),
      ).merge(
        ElevatedButton.styleFrom(elevation: 0),
      ),
      child: const Text(
        "ピルシートの設定",
        style: TextStyle(
          fontFamily: FontFamily.japanese,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: TextColor.main,
        ),
      ),
    );
  }
}
