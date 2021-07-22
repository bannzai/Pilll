import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/domain/premium_trial/premium_trial_complete_modal.dart';
import 'package:pilll/domain/premium_trial/premium_trial_modal.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/entity/setting.dart';

class CreatingNewPillSheetRow extends HookWidget {
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
  Widget build(BuildContext context) {
    final store = useProvider(settingStoreProvider);
    return SwitchListTile(
      title: Row(
        children: [
          Text("ピルシートの自動追加", style: FontType.listRow),
          if (!isPremium) ...[
            SizedBox(width: 8),
            PremiumBadge(),
          ]
        ],
      ),
      activeColor: PilllColors.primary,
      onChanged: (bool value) {
        analytics.logEvent(
          name: "toggle_creating_new_pillsheet",
        );
        if (isPremium || isTrial) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          store
              .modifiyIsAutomaticallyCreatePillSheet(
                  !setting.isAutomaticallyCreatePillSheet)
              .then((state) {
            final setting = state.entity;
            if (setting == null) {
              return null;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 2),
                content: Text(
                  "ピルシートの自動追加を${setting.isAutomaticallyCreatePillSheet ? "ON" : "OFF"}にしました",
                ),
              ),
            );
          });
        } else if (trialDeadlineDate == null) {
          showPremiumTrialModal(context, () {
            showPremiumTrialCompleteModalPreDialog(context);
          });
        } else if (!isPremium) {
          showPremiumIntroductionSheet(context);
        }
      },
      value: setting.isAutomaticallyCreatePillSheet && (isPremium || isTrial),
      contentPadding: EdgeInsets.fromLTRB(14, 8, 6, 8),
    );
  }
}
