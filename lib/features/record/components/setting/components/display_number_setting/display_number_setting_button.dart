import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/record/components/setting/components/display_number_setting/display_number_setting_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';

class DisplayNumberSettingButton extends StatelessWidget {
  final PillSheetGroup pillSheetGroup;

  const DisplayNumberSettingButton({
    Key? key,
    required this.pillSheetGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: const Row(children: [
        Icon(Icons.edit, color: PilllColors.primary),
        SizedBox(width: 6),
        Text(
          "服用日数変更",
          style: TextStyle(
            color: TextColor.main,
            fontSize: 12,
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w700,
          ),
        ),
      ]),
      onTap: () {
        analytics.logEvent(name: "t_r_p_display_number_setting");
        showDisplayNumberSettingSheet(context, pillSheetGroup: pillSheetGroup);
      },
    );
  }
}
