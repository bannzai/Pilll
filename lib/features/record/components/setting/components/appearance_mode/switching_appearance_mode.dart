import 'package:flutter/material.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/features/record/components/setting/components/appearance_mode/select_appearance_mode_modal.dart';
import 'package:pilll/entity/setting.codegen.dart';

class SwitchingAppearanceMode extends StatelessWidget {
  final Setting setting;
  final User user;
  final PillSheetGroup pillSheetGroup;

  const SwitchingAppearanceMode({super.key, required this.setting, required this.user, required this.pillSheetGroup});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.display_settings),
      title: Text(L.displayMode),
      onTap: () {
        analytics.logEvent(name: 'did_tapped_record_page_appearance_mode');
        showSelectAppearanceModeModal(context, user: user, pillSheetGroup: pillSheetGroup);
      },
    );
  }
}
