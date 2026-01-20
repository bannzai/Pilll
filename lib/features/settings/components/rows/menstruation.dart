import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/features/settings/menstruation/page.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class MenstruationRow extends HookConsumerWidget {
  final Setting setting;

  const MenstruationRow(this.setting, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Row(
        children: [
          Text(
            L.aboutMenstruation,
            style: const TextStyle(
              fontFamily: FontFamily.roboto,
              fontWeight: FontWeight.w300,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          if (_hasError) SvgPicture.asset('images/alert_24.svg', width: 24, height: 24),
        ],
      ),
      subtitle: _hasError ? Text(L.checkPillNumberForMenstruationStart) : null,
      onTap: () {
        analytics.logEvent(name: 'did_select_changing_about_menstruation');
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
