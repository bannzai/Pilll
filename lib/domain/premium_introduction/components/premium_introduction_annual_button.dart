import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PremiumIntroductionAnnualButton extends StatelessWidget {
  final Package annualPackage;
  final Function(Package) onTap;

  const PremiumIntroductionAnnualButton(
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
        padding: EdgeInsets.fromLTRB(32, 24, 32, 24),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(
            width: 2,
            color: PilllColors.secondary,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Text("年間プラン"),
              Text("${annualPackage.product.priceString}/年"),
              Text("（$monthlyPriceString/月）"),
            ],
          ),
        ),
      ),
    );
  }
}
