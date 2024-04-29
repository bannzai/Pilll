import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';

class PremiumIntroductionRow extends StatelessWidget {
  final bool isPremium;
  final DateTime? trialDeadlineDate;

  const PremiumIntroductionRow({
    Key? key,
    required this.isPremium,
    required this.trialDeadlineDate,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        analytics.logEvent(name: "tapped_premium_introduction_row");
        showPremiumIntroductionSheet(context);
      },
      title: Row(
        children: [
          SvgPicture.asset("images/crown.svg", width: 24),
          const SizedBox(width: 8),
          const Text("プレミアムプランを見る",
              style: TextStyle(
                fontFamily: FontFamily.roboto,
                fontWeight: FontWeight.w300,
                fontSize: 16,
              )),
        ],
      ),
    );
  }
}
