import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/features/pill_sheet_modified_history/page.dart';
import 'package:pilll/features/premium_introduction/paywall_source.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:flutter/material.dart';

class PillSheetModifiedHistoryMoreButton extends StatelessWidget {
  /// プレミアム会員またはトライアル中か。false の時はタップで Paywall を出す
  final bool premiumOrTrial;
  const PillSheetModifiedHistoryMoreButton({super.key, required this.premiumOrTrial});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AlertButton(
          text: L.viewMore,
          onPressed: () async {
            analytics.logEvent(name: 'pill_sheet_modified_history_more');
            if (premiumOrTrial) {
              Navigator.of(
                context,
              ).push(PillSheetModifiedHistoriesPageRoute.route());
            } else {
              showPremiumIntroductionSheet(context, source: PaywallSource.pillSheetModifiedHistoryMore);
            }
          },
        ),
      ],
    );
  }
}
