import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class LifetimePurchaseButton extends StatelessWidget {
  final Package lifetimePackage;
  final Package? lifetimePremiumPackage;
  final double? discountRate;
  final OfferingType offeringType;
  final Function(Package) onTap;

  const LifetimePurchaseButton({
    super.key,
    required this.lifetimePackage,
    required this.lifetimePremiumPackage,
    required this.discountRate,
    required this.offeringType,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(lifetimePackage);
      },
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 44),
              child: Container(
                padding: const EdgeInsets.fromLTRB(33, 24, 33, 24),
                decoration: BoxDecoration(
                  color: AppColors.blueBackground,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  border: Border.all(width: 2, color: AppColors.primary),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      L.lifetimePlan,
                      style: const TextStyle(
                        color: TextColor.main,
                        fontFamily: FontFamily.japanese,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      lifetimePackage.storeProduct.priceString,
                      style: const TextStyle(
                        color: TextColor.main,
                        fontFamily: FontFamily.japanese,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      L.lifetimePlanDescription,
                      style: const TextStyle(
                        color: TextColor.main,
                        fontFamily: FontFamily.japanese,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (discountRate != null && offeringType == OfferingType.discount)
            Positioned(
              top: -5,
              child: _LifetimeDiscountBadge(
                discountRate: discountRate!,
                lifetimePremiumPackage: lifetimePremiumPackage,
              ),
            ),
        ],
      ),
    );
  }
}

class _LifetimeDiscountBadge extends StatelessWidget {
  final double discountRate;
  final Package? lifetimePremiumPackage;

  const _LifetimeDiscountBadge({
    required this.discountRate,
    required this.lifetimePremiumPackage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.secondary,
      ),
      child: Text(
        '通常買い切り価格の ${lifetimePremiumPackage?.storeProduct.priceString ?? "¥20,000"} よりも ${discountRate.toInt()}％OFF',
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
