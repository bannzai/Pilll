import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/settings/today_pill_number/page.dart';

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
      title: Text(L.changePillNumberForToday),
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
