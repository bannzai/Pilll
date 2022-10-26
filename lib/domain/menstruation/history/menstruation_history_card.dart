import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/app_card.dart';
import 'package:pilll/components/molecules/counter_unit_layout.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/domain/menstruation/history/menstruation_history_card_state.dart';
import 'package:pilll/domain/menstruation_list/menstruation_list_row.dart';
import 'package:pilll/domain/menstruation_list/menstruation_list_page.dart';
import 'package:flutter/material.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_sheet.dart';

class MenstruationHistoryCard extends StatelessWidget {
  final MenstruationHistoryCardState state;

  const MenstruationHistoryCard({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, bottom: 16, right: 16),
        child: GestureDetector(
          onTap: () {
            analytics.logEvent(name: "menstruation_history_card_tapped");
            if (state.isPremium || state.isTrial) {
              return;
            }

            showPremiumIntroductionSheet(context);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MenstruationHistoryCardTitle(state: state),
              const SizedBox(height: 32),
              MenstruationHisotryCardAvarageInformation(state: state),
              const SizedBox(height: 32),
              MenstruationHistoryCardList(state: state),
              MenstruationHistoryCardMoreButton(state: state),
            ],
          ),
        ),
      ),
    );
  }
}

class MenstruationHistoryCardMoreButton extends StatelessWidget {
  const MenstruationHistoryCardMoreButton({
    Key? key,
    required this.state,
  }) : super(key: key);

  final MenstruationHistoryCardState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (!state.moreButtonIsHidden)
          AlertButton(
              text: "もっと見る",
              onPressed: () async {
                analytics.logEvent(name: "menstruation_more_button_pressed");
                if (state.isPremium || state.isTrial) {
                  Navigator.of(context).push(MenstruationListPageRoute.route());
                } else {
                  showPremiumIntroductionSheet(context);
                }
              }),
      ],
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
      children: state.pastRows.map((e) => [MenstruationListRow(state: e), const SizedBox(height: 20)]).expand((e) => e).toList(),
    );
  }
}

class MenstruationHisotryCardAvarageInformation extends StatelessWidget {
  final MenstruationHistoryCardState state;

  const MenstruationHisotryCardAvarageInformation({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        CounterUnitLayout(
          title: "平均周期",
          number: (state.isPremium || state.isTrial) ? state.avalageMenstruationDuration : "🔒",
          unit: "日",
        ),
        const SizedBox(width: 30),
        const SizedBox(
            height: 64,
            child: VerticalDivider(
              color: PilllColors.divider,
              width: 3,
            )),
        const SizedBox(width: 30),
        CounterUnitLayout(
          title: "平均日数",
          number: (state.isPremium || state.isTrial) ? state.avalageMenstruationPeriod : "🔒",
          unit: "日",
        ),
        const Spacer(),
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
        const Text(
          "生理履歴",
          style: TextStyle(
            color: TextColor.main,
            fontFamily: FontFamily.japanese,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (!state.isPremium) ...[
          const SizedBox(width: 8),
          const PremiumBadge(),
        ],
      ],
    );
  }
}
