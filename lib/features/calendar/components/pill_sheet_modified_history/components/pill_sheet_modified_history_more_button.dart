import 'package:pilll/util/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/features/pill_sheet_modified_history/pill_sheet_modified_history_page.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:flutter/material.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';

class PillSheetModifiedHistoryMoreButton extends StatelessWidget {
  final PremiumAndTrial premiumAndTrial;
  const PillSheetModifiedHistoryMoreButton({
    Key? key,
    required this.premiumAndTrial,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AlertButton(
            text: "もっと見る",
            onPressed: () async {
              analytics.logEvent(name: "pill_sheet_modified_history_more");
              if (premiumAndTrial.isPremium || premiumAndTrial.isTrial) {
                Navigator.of(context).push(PillSheetModifiedHistoriesPageRoute.route());
              } else {
                showPremiumIntroductionSheet(context);
              }
            }),
      ],
    );
  }
}
