import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/domain/settings/today_pill_number/setting_today_pill_number_page.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';

class TodayPllNumberRow extends HookConsumerWidget {
  final Setting setting;
  final PillSheetGroup pillSheetGroup;
  final PillSheet activedPillSheet;
  final bool isTrial;
  final bool isPremium;

  const TodayPllNumberRow({
    Key? key,
    required this.setting,
    required this.pillSheetGroup,
    required this.activedPillSheet,
    required this.isTrial,
    required this.isPremium,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(settingStoreProvider.notifier);
    return ListTile(
      title: const Text("今日飲むピル番号の変更", style: FontType.listRow),
      onTap: () => _onTap(
        context,
        store: store,
        setting: setting,
        activedPillSheet: activedPillSheet,
        isTrial: isTrial,
        isPremium: isPremium,
      ),
    );
  }

  _onTap(
    BuildContext context, {
    required SettingStateStore store,
    required Setting setting,
    required PillSheet activedPillSheet,
    required bool isTrial,
    required bool isPremium,
  }) {
    analytics.logEvent(
      name: "did_select_changing_pill_number",
    );
    Navigator.of(context).push(
      SettingTodayPillNumberPageRoute.route(
        setting: setting,
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: activedPillSheet,
        isTrial: isTrial,
        isPremium: isPremium,
      ),
    );
  }
}
