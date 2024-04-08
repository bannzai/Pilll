import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/features/settings/today_pill_number/setting_today_pill_number_page.dart';

class TodayPillNumber extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet activePillSheet;

  const TodayPillNumber({
    super.key,
    required this.pillSheetGroup,
    required this.activePillSheet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.today),
      title: const Text("今日飲むピル番号の変更"),
      onTap: () async {
        await Navigator.of(context).push(
          SettingTodayPillNumberPageRoute.route(
            pillSheetGroup: pillSheetGroup,
            activePillSheet: activePillSheet,
          ),
        );
        if (context.mounted) Navigator.of(context).pop();
      },
    );
  }
}
