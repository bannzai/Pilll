import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class MonthlyPurchaseButton extends StatelessWidget {
  final Package monthlyPackage;
  final Function(Package) onTap;

  const MonthlyPurchaseButton(
      {Key? key, required this.monthlyPackage, required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(monthlyPackage);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(32, 24, 32, 46),
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
              Text(
                "月間プラン",
                style: TextStyle(
                  color: TextColor.main,
                  fontFamily: FontFamily.japanese,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "${monthlyPackage.product.priceString}/年",
                style: TextStyle(
                  color: TextColor.main,
                  fontFamily: FontFamily.japanese,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
