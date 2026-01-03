import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/features/settings/pill_taken_count/page.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';

class PillTakenCountRow extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet activePillSheet;

  const PillTakenCountRow({
    super.key,
    required this.pillSheetGroup,
    required this.activePillSheet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: const Text(
        '1回に服用する錠数',
        style: TextStyle(
          fontFamily: FontFamily.roboto,
          fontWeight: FontWeight.w300,
          fontSize: 16,
        ),
      ),
      trailing: Text(
        '${activePillSheet.pillTakenCount}錠',
        style: const TextStyle(
          fontFamily: FontFamily.roboto,
          fontWeight: FontWeight.w300,
          fontSize: 16,
        ),
      ),
      onTap: () => _onTap(context),
    );
  }

  void _onTap(BuildContext context) {
    analytics.logEvent(
      name: 'did_select_changing_pill_taken_count',
    );
    Navigator.of(context).push(
      SettingPillTakenCountPageRoute.route(
        pillSheetGroup: pillSheetGroup,
        activePillSheet: activePillSheet,
      ),
    );
  }
}
