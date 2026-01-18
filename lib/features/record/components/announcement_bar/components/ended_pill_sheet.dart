import 'package:flutter/material.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/pill_sheet_modified_history/page.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';

class EndedPillSheet extends StatelessWidget {
  final bool isTrial;
  final bool isPremium;

  const EndedPillSheet({super.key, required this.isTrial, required this.isPremium});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        analytics.logEvent(name: 'pill_ended_sheet_tap', parameters: {'isTrial': isTrial, 'isPremium': isPremium});

        if (isPremium || isTrial) {
          Navigator.of(context).push(PillSheetModifiedHistoriesPageRoute.route());
        } else {
          showPremiumIntroductionSheet(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        color: AppColors.primary,
        child: Center(
          child: Column(
            children: [
              Text(
                L.pillSheetEnded,
                style: const TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w600, fontSize: 14, color: TextColor.white),
              ),
              Text(
                L.checkLastTakenDate,
                style: const TextStyle(
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
