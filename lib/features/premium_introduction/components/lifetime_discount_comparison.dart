import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

class LifetimeDiscountComparison extends HookConsumerWidget {
  const LifetimeDiscountComparison({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lifetimeDiscountRate = ref.watch(lifetimeDiscountRateProvider);
    final lifetimePremiumPackage = ref.watch(lifetimePremiumPackageProvider);
    final lifetimeLimitedPackage = ref.watch(lifetimeLimitedPackageProvider);

    if (lifetimeDiscountRate == null || lifetimePremiumPackage == null || lifetimeLimitedPackage == null) {
      return Container();
    }

    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            L.lifetimePlanSpecialOffer,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: FontFamily.japanese,
              fontSize: 20,
              color: TextColor.main,
            ),
          ),
          const SizedBox(height: 20),
          _LifetimePriceComparison(
            lifetimePremiumPackage: lifetimePremiumPackage,
            lifetimeLimitedPackage: lifetimeLimitedPackage,
            discountRate: lifetimeDiscountRate,
          ),
          const SizedBox(height: 8),
          SvgPicture.asset('images/arrow_down.svg'),
        ],
      ),
    );
  }
}

class _LifetimePriceComparison extends StatelessWidget {
  const _LifetimePriceComparison({
    required this.lifetimePremiumPackage,
    required this.lifetimeLimitedPackage,
    required this.discountRate,
  });

  final Package lifetimePremiumPackage;
  final Package lifetimeLimitedPackage;
  final double discountRate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          L.lifetimePlanStandardPrice,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            fontFamily: FontFamily.japanese,
            color: TextColor.black,
          ),
        ),
        const SizedBox(height: 4),
        Stack(
          children: [
            Text(
              lifetimePremiumPackage.storeProduct.priceString,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 28,
                fontFamily: FontFamily.japanese,
                color: TextColor.main,
              ),
            ),
            Positioned(
              left: 24,
              child: SvgPicture.asset('images/strikethrough.svg'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '${discountRate.toInt()}%OFF!',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            fontFamily: FontFamily.japanese,
            color: TextColor.main,
          ),
        ),
      ],
    );
  }
}
