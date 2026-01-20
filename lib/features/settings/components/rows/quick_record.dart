import 'package:flutter/material.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';

class QuickRecordRow extends StatelessWidget {
  final bool isTrial;
  final DateTime? trialDeadlineDate;

  const QuickRecordRow({
    super.key,
    required this.isTrial,
    required this.trialDeadlineDate,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 9,
      title: Row(
        children: [
          Text(
            L.quickRecord,
            style: const TextStyle(
              fontFamily: FontFamily.roboto,
              fontWeight: FontWeight.w300,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 7),
          const PremiumBadge(),
        ],
      ),
      subtitle: Text(L.quickRecordDescription),
      onTap: () {
        analytics.logEvent(name: 'did_select_quick_record_row');
        if (isTrial) {
          return;
        }
        showPremiumIntroductionSheet(context);
      },
    );
  }
}
