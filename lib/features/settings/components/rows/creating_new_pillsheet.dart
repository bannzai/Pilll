import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/setting.dart';

class CreatingNewPillSheetRow extends HookConsumerWidget {
  final Setting setting;
  final bool isTrial;
  final bool isPremium;
  final DateTime? trialDeadlineDate;

  const CreatingNewPillSheetRow({
    Key? key,
    required this.setting,
    required this.isTrial,
    required this.isPremium,
    required this.trialDeadlineDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setSetting = ref.watch(setSettingProvider);
    return SwitchListTile(
      title: Row(
        children: [
          const Text("ピルシートグループの自動追加",
              style: TextStyle(
                fontFamily: FontFamily.roboto,
                fontWeight: FontWeight.w300,
                fontSize: 16,
              )),
          if (!isPremium) ...[
            const SizedBox(width: 8),
            const PremiumBadge(),
          ]
        ],
      ),
      subtitle: const Text("ピルをすべて服用済みの場合、新しいシートを自動で追加します",
          style: TextStyle(
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w300,
            fontSize: 14,
          )),
      activeColor: PilllColors.secondary,
      onChanged: (bool value) async {
        analytics.logEvent(
          name: "toggle_creating_new_pillsheet",
        );
        if (isPremium || isTrial) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          await setSetting(setting.copyWith(isAutomaticallyCreatePillSheet: value));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 2),
            content: Text(
              "ピルシートグループの自動追加を${value ? "ON" : "OFF"}にしました",
            ),
          ));
        } else if (!isPremium) {
          showPremiumIntroductionSheet(context);
        }
      },
      value: setting.isAutomaticallyCreatePillSheet && (isPremium || isTrial),
      contentPadding: const EdgeInsets.fromLTRB(14, 8, 6, 8),
    );
  }
}
