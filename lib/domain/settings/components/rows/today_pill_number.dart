import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/domain/settings/modifing_pill_number_page.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/setting.dart';

class TodayPllNumberRow extends HookWidget {
  final Setting setting;
  final PillSheet activedPillSheet;

  const TodayPllNumberRow({
    Key? key,
    required this.setting,
    required this.activedPillSheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = useProvider(settingStoreProvider);
    return ListTile(
      title: Text("今日飲むピル番号の変更", style: FontType.listRow),
      onTap: () => _onTap(context, store, setting, activedPillSheet),
    );
  }

  _onTap(BuildContext context, SettingStateStore store, Setting setting,
      PillSheet activedPillSheet) {
    analytics.logEvent(
      name: "did_select_changing_pill_number",
    );
    Navigator.of(context).push(
      ModifingPillNumberPageRoute.route(
        activedPillSheet: activedPillSheet,
        isOnSequenceAppearance: setting.isOnSequenceAppearance,
        markSelected: (number) {
          Navigator.pop(context);
          store.modifyBeginingDate(number);
        },
      ),
    );
  }
}
