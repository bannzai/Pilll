import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/features/settings/today_pill_number/page.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';

class TodayPllNumberRow extends HookConsumerWidget {
  final Setting setting;
  final PillSheetGroup pillSheetGroup;
  final PillSheet activePillSheet;

  const TodayPllNumberRow({super.key, required this.setting, required this.pillSheetGroup, required this.activePillSheet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(
        L.changePillNumberForToday,
        style: const TextStyle(fontFamily: FontFamily.roboto, fontWeight: FontWeight.w300, fontSize: 16),
      ),
      onTap: () => _onTap(context, setting, activePillSheet),
    );
  }

  void _onTap(BuildContext context, Setting setting, PillSheet activePillSheet) {
    analytics.logEvent(name: 'did_select_changing_pill_number');
    Navigator.of(context).push(SettingTodayPillNumberPageRoute.route(pillSheetGroup: pillSheetGroup, activePillSheet: activePillSheet));
  }
}
