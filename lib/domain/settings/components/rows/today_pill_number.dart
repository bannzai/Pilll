import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/domain/settings/today_pill_number/setting_today_pill_number_page.dart';
import 'package:pilll/domain/settings/setting_page_state_notifier.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';

class TodayPllNumberRow extends HookConsumerWidget {
  final Setting setting;
  final PillSheetGroup pillSheetGroup;
  final PillSheet activedPillSheet;

  const TodayPllNumberRow({
    Key? key,
    required this.setting,
    required this.pillSheetGroup,
    required this.activedPillSheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(settingStoreProvider.notifier);
    return ListTile(
      title: const Text("今日飲むピル番号の変更", style: FontType.listRow),
      onTap: () => _onTap(context, store, setting, activedPillSheet),
    );
  }

  _onTap(BuildContext context, SettingStateStore store, Setting setting,
      PillSheet activedPillSheet) {
    analytics.logEvent(
      name: "did_select_changing_pill_number",
    );
    Navigator.of(context).push(
      SettingTodayPillNumberPageRoute.route(
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: activedPillSheet,
      ),
    );
  }
}
