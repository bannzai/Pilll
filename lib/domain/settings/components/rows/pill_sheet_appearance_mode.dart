import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/domain/premium_trial/premium_trial_complete_modal.dart';
import 'package:pilll/domain/premium_trial/premium_trial_modal.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/entity/setting.dart';

class PillSheetAppearanceModeRow extends HookWidget {
  final bool isPremium;
  final bool isTrial;
  final DateTime? trialDeadlineDate;
  final Setting setting;

  const PillSheetAppearanceModeRow({
    Key? key,
    required this.isTrial,
    required this.isPremium,
    required this.trialDeadlineDate,
    required this.setting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = useProvider(settingStoreProvider);
    final isOn =
        setting.pillSheetAppearanceMode == PillSheetAppearanceMode.date;
    return ListTile(
      title: Row(
        children: [
          Text("日付表示モード", style: FontType.listRow),
          SizedBox(width: 8),
          PremiumBadge(),
        ],
      ),
      trailing: Switch(
        value: isOn,
        onChanged: (value) => _onChanged(context, value, store),
      ),
      onTap: () => _onChanged(context, !isOn, store),
    );
  }

  _onChanged(
    BuildContext context,
    bool isOn,
    SettingStateStore store,
  ) async {
    analytics.logEvent(
      name: "did_select_pill_sheet_appearance",
    );
    if (isPremium || isTrial) {
      final pillSheetAppearanceMode =
          isOn ? PillSheetAppearanceMode.date : PillSheetAppearanceMode.number;
      await store.modifyPillSheetAppearanceMode(pillSheetAppearanceMode);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            "日付表示モードを${isOn ? "有効" : "無効"}にしました",
          ),
        ),
      );
    } else {
      if (trialDeadlineDate == null) {
        showPremiumTrialModal(context, () {
          showPremiumTrialCompleteModalPreDialog(context);
        });
      } else {
        showPremiumIntroductionSheet(context);
      }
    }
  }
}
