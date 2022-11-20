import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/util/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/features/settings/menstruation/setting_menstruation_page.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class MenstruationRow extends HookConsumerWidget {
  final Setting setting;

  const MenstruationRow(this.setting, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Row(
        children: [
          const Text("生理について",
              style: TextStyle(
                fontFamily: FontFamily.roboto,
                fontWeight: FontWeight.w300,
                fontSize: 16,
              )),
          const SizedBox(width: 8),
          if (_hasError) SvgPicture.asset("images/alert_24.svg", width: 24, height: 24),
        ],
      ),
      subtitle: _hasError ? const Text("生理開始日のピル番号をご確認ください。現在選択しているピルシートタイプには存在しないピル番号が設定されています") : null,
      onTap: () {
        analytics.logEvent(
          name: "did_select_changing_about_menstruation",
        );
        Navigator.of(context).push(SettingMenstruationPageRoute.route());
      },
    );
  }

  bool get _hasError {
    if (setting.pillSheetEnumTypes.isEmpty) {
      return false;
    }

    final totalCount = setting.pillSheetEnumTypes.map((e) => e.totalCount).reduce((value, element) => value + element);
    return totalCount < setting.pillNumberForFromMenstruation;
  }
}
