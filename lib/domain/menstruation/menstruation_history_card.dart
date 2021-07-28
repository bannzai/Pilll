import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/app_card.dart';
import 'package:pilll/components/molecules/counter_unit_layout.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/domain/menstruation/menstruation_history_card_state.dart';
import 'package:pilll/domain/menstruation_list/menstruation_list_row.dart';
import 'package:pilll/domain/menstruation_list/menstruation_list_page.dart';
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
            MenstruationHistoryCardTitle(state: state),
            SizedBox(height: 32),
            MenstruationHisotryCardAvarageInformation(),
            SizedBox(height: 32),
            MenstruationHistoryCardList(state: state),
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

class MenstruationHistoryCardList extends StatelessWidget {
  const MenstruationHistoryCardList({
    Key? key,
    required this.state,
  }) : super(key: key);

  final MenstruationHistoryCardState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: state.rows
          .map((e) => [MenstruationListRow(state: e), SizedBox(height: 20)])
          .expand((e) => e)
          .toList(),
    );
  }
}

class MenstruationHisotryCardAvarageInformation extends StatelessWidget {
  const MenstruationHisotryCardAvarageInformation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        CounterUnitLayout(title: "平均周期", number: 28, unit: "日"),
        SizedBox(width: 30),
        Container(
            height: 64,
            child: VerticalDivider(
              color: PilllColors.divider,
              width: 3,
            )),
        SizedBox(width: 30),
        CounterUnitLayout(title: "平均日数", number: 5, unit: "日"),
        Spacer(),
      ],
    );
  }
}

class MenstruationHistoryCardTitle extends StatelessWidget {
  const MenstruationHistoryCardTitle({
    Key? key,
    required this.state,
  }) : super(key: key);

  final MenstruationHistoryCardState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "生理履歴",
          style: TextStyle(
            color: TextColor.main,
            fontFamily: FontFamily.japanese,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (!state.isPremium) ...[
          SizedBox(width: 8),
          PremiumBadge(),
        ],
      ],
    );
  }
}
