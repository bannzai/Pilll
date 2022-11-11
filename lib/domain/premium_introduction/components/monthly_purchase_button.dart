import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class MonthlyPurchaseButton extends StatelessWidget {
  final Package monthlyPackage;
  final Function(Package) onTap;

  const MonthlyPurchaseButton({
    Key? key,
    required this.monthlyPackage,
    required this.onTap,
  }) : super(key: key);
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
            color: PilllColors.secondary,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "月額プラン",
              style: TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "${monthlyPackage.storeProduct.priceString}/月",
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
