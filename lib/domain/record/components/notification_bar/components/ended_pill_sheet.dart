import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/pill_sheet_modified_history/pill_sheet_modified_history_page.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/domain/premium_trial/premium_trial_complete_modal.dart';
import 'package:pilll/domain/premium_trial/premium_trial_modal.dart';

class EndedPillSheet extends StatelessWidget {
  final bool isTrial;
  final bool isPremium;
  final DateTime? trialDeadlineDate;

  const EndedPillSheet({
    Key? key,
    required this.isTrial,
    required this.isPremium,
    required this.trialDeadlineDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        analytics.logEvent(name: "pill_ended_sheet_tap", parameters: {
          "isTrial": isTrial,
          "isPremium": isPremium,
          "trialDeadlineDate": trialDeadlineDate,
        });

        if (isPremium || isTrial) {
          Navigator.of(context)
              .push(PillSheetModifiedHistoriesPageRoute.route());
        } else {
          showPremiumIntroductionSheet(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Center(
          child: Column(
            children: [
              Text(
                "ピルシートが終了しました",
                style: FontType.assistingBold.merge(
                  TextColorStyle.white,
                ),
              ),
              const Text(
                "最後に服用した日を確認",
                style: TextStyle(
                  color: TextColor.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: FontFamily.japanese,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
