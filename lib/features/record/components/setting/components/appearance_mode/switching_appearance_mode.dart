import 'package:flutter/material.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/record/components/setting/components/appearance_mode/select_appearance_mode_modal.dart';
import 'package:pilll/entity/setting.codegen.dart';

class SwitchingAppearanceMode extends StatelessWidget {
  final Setting setting;
  final User user;

  const SwitchingAppearanceMode({
    Key? key,
    required this.setting,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.display_settings),
      title: const Text(
        "表示モード",
      ),
      onTap: () {
        analytics.logEvent(name: "did_tapped_record_page_appearance_mode");
        showSelectAppearanceModeModal(context, user: user);
      },
    );
  }
}
