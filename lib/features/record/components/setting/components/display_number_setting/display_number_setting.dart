import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/features/record/components/setting/components/display_number_setting/display_number_setting_sheet.dart';
import 'package:pilll/utils/analytics.dart';

class BeginManualRestDuration extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;

  const BeginManualRestDuration({
    super.key,
    required this.pillSheetGroup,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.stop_circle, color: PilllColors.primary),
      title: const Text(
        "服用日数変更",
        style: TextStyle(
          color: TextColor.main,
          fontSize: 12,
          fontFamily: FontFamily.japanese,
          fontWeight: FontWeight.w700,
        ),
      ),
      onTap: () {
        analytics.logEvent(name: "t_r_p_display_number_setting");
        showDisplayNumberSettingSheet(context, pillSheetGroup: pillSheetGroup);
      },
    );
  }
}
