import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class AnnualPurchaseButton extends StatelessWidget {
  final Package monthlyPackage;
  final Package annualPackage;
  final Package monthlyPremiumPackage;
  final OfferingType offeringType;
  final Function(Package) onTap;

  const AnnualPurchaseButton({
    super.key,
    required this.monthlyPackage,
    required this.annualPackage,
    required this.monthlyPremiumPackage,
    required this.offeringType,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final monthlyPrice = annualPackage.storeProduct.price / 12;
    Locale locale = Localizations.localeOf(context);
    final monthlyPriceString = NumberFormat.simpleCurrency(locale: locale.toString(), decimalDigits: 0).format(monthlyPrice);

    return GestureDetector(
      onTap: () {
        onTap(annualPackage);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(33, 24, 33, 24),
            decoration: BoxDecoration(
              color: PilllColors.blueBackground,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(
                width: 2,
                color: PilllColors.primary,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  L.annualPlan,
                  style: const TextStyle(
                    color: TextColor.main,
                    fontFamily: FontFamily.japanese,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  L.annualPrice(annualPackage.storeProduct.priceString),
                  style: const TextStyle(
                    color: TextColor.main,
                    fontFamily: FontFamily.japanese,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  L.monthlyPrice(monthlyPriceString),
                  style: const TextStyle(
                    color: TextColor.main,
                    fontFamily: FontFamily.japanese,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -11,
            right: 8,
            child: _DiscountBadge(
              offeringType: offeringType,
              monthlyPackage: monthlyPackage,
              annualPackage: annualPackage,
              monthlyPremiumPackage: monthlyPremiumPackage,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  final OfferingType offeringType;
  final Package monthlyPackage;
  final Package annualPackage;
  final Package monthlyPremiumPackage;

  const _DiscountBadge({
    required this.offeringType,
    required this.monthlyPackage,
    required this.annualPackage,
    required this.monthlyPremiumPackage,
  });

  @override
  Widget build(BuildContext context) {
    final offPercentFormonthlyPremiumPackage = ((1 - (monthlyPremiumPackage.storeProduct.price / annualPackage.storeProduct.price)) * 100).toInt();
    final offPercentForMonthlyPackage = ((1 - (annualPackage.storeProduct.price / monthlyPackage.storeProduct.price * 12)) * 100).toInt();

    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: PilllColors.secondary,
      ),
      child: Text(
        offeringType == OfferingType.limited ? '通常月額と比べて$offPercentFormonthlyPremiumPackage％OFF' : '通常月額と比べて$offPercentForMonthlyPackage％OFF',
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 10,
          fontFamily: FontFamily.japanese,
          color: TextColor.white,
        ),
      ),
    );
  }
}
