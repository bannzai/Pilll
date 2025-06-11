import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class LifetimePurchaseButton extends StatelessWidget {
  final Package lifetimePackage;
  final Function(Package) onTap;

  const LifetimePurchaseButton({
    super.key,
    required this.lifetimePackage,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(lifetimePackage);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(33, 24, 33, 24),
        decoration: BoxDecoration(
          color: AppColors.blueBackground,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          border: Border.all(
            width: 2,
            color: AppColors.primary,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
          ],
        ),
      ),
    );
  }
}
