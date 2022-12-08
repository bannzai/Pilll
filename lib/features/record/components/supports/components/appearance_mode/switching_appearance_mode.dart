import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/record/components/supports/components/appearance_mode/select_appearance_mode_modal.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';

class SwitchingAppearanceMode extends StatelessWidget {
  final Setting setting;
  final PremiumAndTrial premiumAndTrial;

  const SwitchingAppearanceMode({
    Key? key,
    required this.setting,
    required this.premiumAndTrial,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(children: [
        const Text(
          "表示モード",
          style: TextStyle(
            color: TextColor.main,
            fontSize: 12,
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 6),
        SvgPicture.asset("images/switching_appearance_mode.svg"),
      ]),
      onTap: () {
        analytics.logEvent(name: "did_tapped_record_page_appearance_mode");
        showSelectAppearanceModeModal(context, premiumAndTrial: premiumAndTrial);
      },
    );
  }
}
