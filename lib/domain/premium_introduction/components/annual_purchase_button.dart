import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class AnnualPurchaseButton extends StatelessWidget {
  final Package annualPackage;
  final Function(Package) onTap;

  const AnnualPurchaseButton(
      {Key? key, required this.annualPackage, required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final monthlyPrice = annualPackage.product.price / 12;
    final monthlyPriceString =
        NumberFormat.simpleCurrency(decimalDigits: 0, name: "JPY")
            .format(monthlyPrice);
    return GestureDetector(
      onTap: () {
        onTap(annualPackage);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(33, 24, 33, 24),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(
            width: 2,
            color: PilllColors.secondary,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "年間プラン",
              style: TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "${annualPackage.product.priceString}/年",
              style: TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "（$monthlyPriceString/月）",
              style: TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
