import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_card.dart';
import 'package:pilll/domain/pill_sheet_modified_history/pill_sheet_modified_history_page.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_sheet.dart';
import 'package:flutter/material.dart';

class PillSheetModifiedHistoryMoreButton extends StatelessWidget {
  const PillSheetModifiedHistoryMoreButton({
    Key? key,
    required this.state,
  }) : super(key: key);

  final CalendarPillSheetModifiedHistoryCardState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AlertButton(
            text: "もっと見る",
            onPressed: () async {
              analytics.logEvent(name: "pill_sheet_modified_history_more");
              if (state.isPremium || state.isTrial) {
                Navigator.of(context)
                    .push(PillSheetModifiedHistoriesPageRoute.route());
              } else {
                showPremiumIntroductionSheet(context);
              }
            }),
      ],
    );
  }
}
