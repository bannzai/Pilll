import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class MonthlyPurchaseButton extends StatelessWidget {
  final Package monthlyPackage;
  final Function(Package) onTap;

  const MonthlyPurchaseButton({
    super.key,
    required this.monthlyPackage,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(monthlyPackage);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(32, 24, 32, 45),
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
              L.monthlyPlan,
              style: const TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              L.monthlyPrice(monthlyPackage.storeProduct.priceString),
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
