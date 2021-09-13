import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/domain/settings/menstruation/setting_menstruation_page.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class MenstruationRow extends HookWidget {
  final SettingStateStore store;
  final Setting setting;
  final PillSheetGroup pillSheetGroup;

  MenstruationRow(this.store, this.setting, this.pillSheetGroup);

  @override
  Widget build(BuildContext context) {
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
    if (setting.pillSheetTypes.isEmpty) {
      return false;
    }
    if (setting.menstruations.length != setting.pillSheetTypes.length) {
      return true;
    }
    final isExistsInValidCase = setting.pillSheetTypes
        .asMap()
        .keys
        .map((index) {
          return setting.menstruations[index].pillNumberForFromMenstruation >
              setting.pillSheetTypes[index].totalCount;
        })
        .where((element) => element)
        .isNotEmpty;
    return isExistsInValidCase;
  }
}
