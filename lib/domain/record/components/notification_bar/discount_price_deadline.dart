import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/premium_introduction/util/discount_deadline.dart';

class DiscountPriceDeadline extends HookWidget {
  final DateTime discountEntitlementDeadlineDate;
  final VoidCallback onTap;

  DiscountPriceDeadline({
    required this.discountEntitlementDeadlineDate,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final difference = useProvider(
        durationToDiscountPriceDeadline(discountEntitlementDeadlineDate));
    if (difference.inSeconds <= 0) {
      return Container();
    }
    final countdown = discountPriceDeadlineCountdownString(difference);
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "トライアル期間が終了しました\n$countdown内に購入すると割引価格で購入できます",
                style: FontType.assistingBold.merge(TextColorStyle.white),
                textAlign: TextAlign.center,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: SvgPicture.asset(
                  "images/arrow_right.svg",
                  color: Colors.white,
                ),
                onPressed: () {},
                iconSize: 24,
                padding: EdgeInsets.all(8),
                alignment: Alignment.centerRight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
