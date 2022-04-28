import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/components/molecules/select_circle.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/domain/premium_trial/premium_trial_complete_modal.dart';
import 'package:pilll/domain/premium_trial/premium_trial_modal.dart';
import 'package:pilll/domain/record/record_page_state.codegen.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/setting.codegen.dart';

class SelectAppearanceModeModal extends HookConsumerWidget {
  final RecordPageStore store;
  final RecordPageState state;

  SelectAppearanceModeModal(this.store, this.state);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  store: store,
                  state: state,
                  mode: PillSheetAppearanceMode.date,
                  text: "日付表示",
                  isPremiumFunction: true,
                ),
                _row(
                  context,
                  store: store,
                  state: state,
                  mode: PillSheetAppearanceMode.number,
                  text: "ピル番号",
                  isPremiumFunction: false,
                ),
                _row(
                  context,
                  store: store,
                  state: state,
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
    required RecordPageStore store,
    required RecordPageState state,
    required PillSheetAppearanceMode mode,
    required String text,
    required bool isPremiumFunction,
  }) {
    return GestureDetector(
      onTap: () {
        analytics.logEvent(
          name: "did_select_pill_sheet_appearance",
          parameters: {
            "mode": mode.toString(),
            "isPremiumFunction": isPremiumFunction
          },
        );

        if (state.isPremium || state.isTrial) {
          store.switchingAppearanceMode(mode);
        } else if (isPremiumFunction) {
          if (state.trialDeadlineDate == null) {
            showPremiumTrialModal(context, () {
              showPremiumTrialCompleteModalPreDialog(context);
            });
          } else {
            showPremiumIntroductionSheet(context);
          }
        } else {
          // User selected non premium function mode
          store.switchingAppearanceMode(mode);
        }
      },
      child: Container(
        height: 48,
        child: Row(
          children: [
            SelectCircle(isSelected: mode == state.appearanceMode),
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
              PremiumBadge(),
            ]
          ],
        ),
      ),
    );
  }
}

void showSelectAppearanceModeModal(
  BuildContext context,
) {
  analytics.setCurrentScreen(screenName: "SelectAppearanceModeModal");
  showModalBottomSheet(
    context: context,
    builder: (context) => SelectAppearanceModeModal(),
    backgroundColor: Colors.transparent,
  );
}
