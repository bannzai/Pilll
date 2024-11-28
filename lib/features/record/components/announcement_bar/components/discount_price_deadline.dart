import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/premium_introduction/util/discount_deadline.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/provider/user.dart';

class DiscountPriceDeadline extends HookConsumerWidget {
  final DateTime discountEntitlementDeadlineDate;
  final VoidCallback onTap;

  const DiscountPriceDeadline({
    super.key,
    required this.discountEntitlementDeadlineDate,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).valueOrNull;
    final difference = ref.watch(durationToDiscountPriceDeadlineProvider(discountEntitlementDeadlineDate: discountEntitlementDeadlineDate));
    final annualPackage = user != null ? ref.watch(annualPackageProvider(user)) : null;
    final monthlyPremiumPackage = user != null ? ref.watch(monthlyPremiumPackageProvider(user)) : null;
    if (difference.inSeconds <= 0 || annualPackage == null || monthlyPremiumPackage == null) {
      return Container();
    }

    final countdown = discountPriceDeadlineCountdownString(difference);
    // NOTE: [DiscountPercent]
    final offPercentForMonthlyPremiumPackage =
        ((1 - (annualPackage.storeProduct.price / (monthlyPremiumPackage.storeProduct.price * 12))) * 100).toInt();

    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 4, left: 8, right: 8),
      color: PilllColors.primary,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                '${L.premiumIntroductionDiscountPriceDeadline}\n${L.countdownForDiscountPriceDeadline(countdown, offPercentForMonthlyPremiumPackage)}',
                style: const TextStyle(
                  fontFamily: FontFamily.japanese,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: TextColor.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: SvgPicture.asset(
                  'images/arrow_right.svg',
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
                onPressed: () {},
                iconSize: 24,
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
