import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/components/molecules/select_circle.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/provider/setting.dart';

class SelectAppearanceModeModal extends HookConsumerWidget {
  final Setting setting;
  final PremiumAndTrial premiumAndTrial;

  const SelectAppearanceModeModal({Key? key, required this.setting, required this.premiumAndTrial}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setSetting = ref.watch(setSettingProvider);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 20, top: 24, left: 16, right: 16),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "表示モード",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: FontFamily.japanese,
                color: TextColor.main,
              ),
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                _row(
                  context,
                  setting: setting,
                  setSetting: setSetting,
                  premiumAndTrial: premiumAndTrial,
                  mode: PillSheetAppearanceMode.date,
                  text: "日付表示",
                  isPremiumFunction: true,
                ),
                _row(
                  context,
                  setting: setting,
                  setSetting: setSetting,
                  premiumAndTrial: premiumAndTrial,
                  mode: PillSheetAppearanceMode.number,
                  text: "ピル番号",
                  isPremiumFunction: false,
                ),
                _row(
                  context,
                  setting: setting,
                  setSetting: setSetting,
                  premiumAndTrial: premiumAndTrial,
                  mode: PillSheetAppearanceMode.sequential,
                  text: "服用日数",
                  isPremiumFunction: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(
    BuildContext context, {
    required SetSetting setSetting,
    required Setting setting,
    required PremiumAndTrial premiumAndTrial,
    required PillSheetAppearanceMode mode,
    required String text,
    required bool isPremiumFunction,
  }) {
    return GestureDetector(
      onTap: () async {
        analytics.logEvent(
          name: "did_select_pill_sheet_appearance",
          parameters: {"mode": mode.toString(), "isPremiumFunction": isPremiumFunction},
        );

        if (premiumAndTrial.isPremium || premiumAndTrial.isTrial) {
          await setSetting(setting.copyWith(pillSheetAppearanceMode: mode));
        } else if (isPremiumFunction) {
          showPremiumIntroductionSheet(context);
        } else {
          // User selected non premium function mode
          await setSetting(setting.copyWith(pillSheetAppearanceMode: mode));
        }
      },
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            SelectCircle(isSelected: mode == setting.pillSheetAppearanceMode),
            const SizedBox(width: 34),
            Text(
              text,
              style: const TextStyle(
                color: TextColor.main,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            if (isPremiumFunction) ...[
              const SizedBox(width: 12),
              const PremiumBadge(),
            ]
          ],
        ),
      ),
    );
  }
}

void showSelectAppearanceModeModal(
  BuildContext context, {
  required Setting setting,
  required PremiumAndTrial premiumAndTrial,
}) {
  analytics.setCurrentScreen(screenName: "SelectAppearanceModeModal");
  showModalBottomSheet(
    context: context,
    builder: (context) => SelectAppearanceModeModal(
      setting: setting,
      premiumAndTrial: premiumAndTrial,
    ),
    backgroundColor: Colors.transparent,
  );
}
