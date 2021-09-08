import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/domain/settings/setting_account_list/menstruation_page.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class MenstruationRow extends HookWidget {
  final Setting setting;
  final PillSheetGroup pillSheetGroup;

  MenstruationRow(this.setting, this.pillSheetGroup);

  @override
  Widget build(BuildContext context) {
    final store = useProvider(settingStoreProvider);
    return ListTile(
      title: Row(
        children: [
          Text("生理について", style: FontType.listRow),
          SizedBox(width: 8),
          if (_hasError)
            SvgPicture.asset("images/alert_24.svg", width: 24, height: 24),
        ],
      ),
      subtitle: _hasError
          ? Text("生理開始日のピル番号をご確認ください。現在選択しているピルシートタイプには存在しないピル番号が設定されています")
          : null,
      onTap: () {
        analytics.logEvent(
          name: "did_select_changing_about_menstruation",
        );
        Navigator.of(context).push(SettingMenstruationPageRoute.route());
      },
    );
  }

  bool get _hasError {
    return setting.pillSheetTypes
                .map((e) => e.totalCount)
                .reduce((value, element) => value + element) *
            pillSheetGroup.pillSheets.length <
        setting.pillNumberForFromMenstruation;
  }
}
