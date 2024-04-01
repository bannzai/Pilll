import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/features/record/components/setting/components/display_number_setting/display_number_setting_sheet.dart';
import 'package:pilll/utils/analytics.dart';

class DisplayNumberSetting extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;

  const DisplayNumberSetting({
    super.key,
    required this.pillSheetGroup,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.change_circle_outlined),
      title: const Text(
        "服用日数変更",
      ),
      onTap: () {
        analytics.logEvent(name: "t_r_p_display_number_setting");
        showDisplayNumberSettingSheet(context, pillSheetGroup: pillSheetGroup);
      },
    );
  }
}
