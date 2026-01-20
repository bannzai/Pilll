import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    Locale locale = Localizations.localeOf(context);
    // NOTE: [DailyPrice] 日額を表示してみる。since: 2025-05-21。効果がなかったら dailyPriceString を表示しないようにする
    final dailyPriceString = NumberFormat.simpleCurrency(
      locale: locale.toString(),
      decimalDigits: 2,
    ).format(monthlyPackage.storeProduct.price / 30);

    return GestureDetector(
      onTap: () {
        onTap(monthlyPackage);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(33, 24, 33, 24),
        decoration: BoxDecoration(
          color: AppColors.blueBackground,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          border: Border.all(width: 2, color: AppColors.primary),
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
                fontWeight: FontWeight.w400,
              ),
            ),
            // NOTE: [DailyPrice] 日額を表示してみる。since: 2025-05-21。効果がなかったら dailyPriceString を表示しないようにする(Widget削除)
            Text(
              L.dailyPrice(dailyPriceString),
              style: const TextStyle(color: TextColor.main),
            ),
          ],
        ),
      ),
    );
  }
}
