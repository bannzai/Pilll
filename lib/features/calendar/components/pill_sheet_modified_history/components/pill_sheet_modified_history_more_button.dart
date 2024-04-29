import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/features/pill_sheet_modified_history/pill_sheet_modified_history_page.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:flutter/material.dart';

class PillSheetModifiedHistoryMoreButton extends StatelessWidget {
  final User user;
  const PillSheetModifiedHistoryMoreButton({
    Key? key,
    required this.user,
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
              if (user.isPremium || user.isTrial) {
                Navigator.of(context).push(PillSheetModifiedHistoriesPageRoute.route());
              } else {
                showPremiumIntroductionSheet(context);
              }
            }),
      ],
    );
  }
}
