import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/domain/settings/setting_page_state_notifier.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/error/error_alert.dart';

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
    final store = ref.watch(settingStateNotifierProvider.notifier);
    return SwitchListTile(
      title: Row(
        children: [
          const Text("ピルシートグループの自動追加", style: FontType.listRow),
          if (!isPremium) ...[
            const SizedBox(width: 8),
            PremiumBadge(),
          ]
        ],
      ),
      subtitle: const Text("ピルをすべて服用済みの場合、新しいシートを自動で追加します",
          style: FontType.assisting),
      activeColor: PilllColors.primary,
      onChanged: (bool value) {
        analytics.logEvent(
          name: "toggle_creating_new_pillsheet",
        );
        if (isPremium || isTrial) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          store.asyncAction
              .modifiyIsAutomaticallyCreatePillSheet(
                  !setting.isAutomaticallyCreatePillSheet, setting)
              .catchError((error) => showErrorAlertFor(context, error))
              .then(
                (_) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    content: Text(
                      "ピルシートグループの自動追加を${value ? "ON" : "OFF"}にしました",
                    ),
                  ),
                ),
              );
        } else if (!isPremium) {
          showPremiumIntroductionSheet(context);
        }
      },
      value: setting.isAutomaticallyCreatePillSheet && (isPremium || isTrial),
      contentPadding: const EdgeInsets.fromLTRB(14, 8, 6, 8),
    );
  }
}
