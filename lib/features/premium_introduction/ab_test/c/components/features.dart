import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/localizations/l.dart';

class PremiumIntroductionFeatures extends StatelessWidget {
  const PremiumIntroductionFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L.premiumFeaturesList,
          style: const TextStyle(
            fontFamily: FontFamily.japanese,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: TextColor.primaryDarkBlue,
          ),
        ),
        const SizedBox(height: 8),
        DefaultTextStyle(
          style: const TextStyle(
            fontFamily: FontFamily.japanese,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: TextColor.main,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(L.pushNotificationForTakingRecord),
              const SizedBox(height: 4),
              Text(L.viewAndRecordTakingHistory),
              const SizedBox(height: 4),
              Text(L.displayDateOnPillSheet),
              const SizedBox(height: 4),
              Text(L.autoRefillNewPillSheet),
              const SizedBox(height: 4),
              Text(L.viewPastData),
              const SizedBox(height: 4),
              Text(L.customizeHealthTags),
              const SizedBox(height: 4),
              Text(L.hideAds),
            ],
          ),
        ),
      ],
    );
  }
}
