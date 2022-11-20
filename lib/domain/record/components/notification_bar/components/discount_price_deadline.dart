import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/premium_introduction/util/discount_deadline.dart';

class DiscountPriceDeadline extends HookConsumerWidget {
  final DateTime discountEntitlementDeadlineDate;
  final VoidCallback onTap;

  const DiscountPriceDeadline({
    Key? key,
    required this.discountEntitlementDeadlineDate,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final difference = ref.watch(durationToDiscountPriceDeadline(discountEntitlementDeadlineDate));
    if (difference.inSeconds <= 0) {
      return Container();
    }
    final countdown = discountPriceDeadlineCountdownString(difference);
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 4, left: 8, right: 8),
      color: PilllColors.primary,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                """
プレミアム登録で引き続きすべての機能が利用できます
$countdown内の購入で48%OFF!""",
                style: const TextStyle(
                  fontFamily: FontFamily.japanese,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ).merge(TextColorStyle.white),
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
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
