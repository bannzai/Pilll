import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/app_card.dart';
import 'package:pilll/domain/menstruation/menstruation_history_card_state.dart';
import 'package:pilll/domain/menstruation/menstruation_history_row.dart';
import 'package:pilll/domain/menstruation/menstruation_list_page.dart';
import 'package:flutter/material.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/domain/premium_trial/premium_trial_complete_modal.dart';
import 'package:pilll/domain/premium_trial/premium_trial_modal.dart';

class MenstruationHistoryCard extends StatelessWidget {
  final MenstruationHistoryCardState state;

  const MenstruationHistoryCard({Key? key, required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 16, left: 16, bottom: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("生理履歴", style: FontType.sBigTitle.merge(TextColorStyle.main)),
            SizedBox(height: 32),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: state.rows
                  .map((e) =>
                      [MenstruationHistoryRow(state: e), SizedBox(height: 20)])
                  .expand((e) => e)
                  .toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!state.moreButtonIsHidden)
                  SecondaryButton(
                      text: "もっと見る",
                      onPressed: () {
                        if (state.isPremium || state.isTrial) {
                          analytics.logEvent(
                              name: "menstruation_more_button_pressed");
                          Navigator.of(context)
                              .push(MenstruationListPageRoute.route());
                        } else {
                          if (state.trialDeadlineDate == null) {
                            showPremiumTrialModal(context, () {
                              showPremiumTrialCompleteModalPreDialog(context);
                            });
                          } else {
                            showPremiumIntroductionSheet(context);
                          }
                        }
                      }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
