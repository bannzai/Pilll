import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/premium_introduction/util/currency.dart';
import 'package:pilll/features/premium_introduction/util/discount_deadline.dart';
import 'package:purchases_flutter/object_wrappers.dart';

class PremiumIntroductionDiscountRow extends HookConsumerWidget {
  final Package monthlyPremiumPackage;
  final DateTime? discountEntitlementDeadlineDate;

  const PremiumIntroductionDiscountRow({
    Key? key,
    required this.discountEntitlementDeadlineDate,
    required this.monthlyPremiumPackage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Androidで審査落とされたので一時的にifを入れる。2023-10に外す。フォントサイズを調整するかも
    if (Platform.isAndroid) return Container();

    final discountEntitlementDeadlineDate = this.discountEntitlementDeadlineDate;
    final Duration? diff;
    final String? countdown;
    if (discountEntitlementDeadlineDate != null) {
      final tmpDiff = ref.watch(durationToDiscountPriceDeadline(discountEntitlementDeadlineDate));
      countdown = discountPriceDeadlineCountdownString(tmpDiff);
      diff = tmpDiff;
    } else {
      countdown = null;
      diff = null;
    }

    if (diff != null && diff.inSeconds < 0) {
      return Container();
    }

    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "今なら限定価格でずっと使える",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: FontFamily.japanese,
              fontSize: 20,
              color: TextColor.main,
            ),
          ),
          const SizedBox(height: 4),
          if (countdown != null)
            Text(
              countdown,
              style: const TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "通常 月額プラン",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  fontFamily: FontFamily.japanese,
                  color: TextColor.black,
                ),
              ),
              const SizedBox(height: 4),
              Stack(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: currencySymbol(context),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            fontFamily: FontFamily.japanese,
                            color: TextColor.main,
                          ),
                        ),
                        TextSpan(
                          text: removeZero(monthlyPremiumPackage.storeProduct.price),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 28,
                            fontFamily: FontFamily.japanese,
                            color: TextColor.main,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 24,
                    child: SvgPicture.asset("images/strikethrough.svg"),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          SvgPicture.asset("images/arrow_down.svg"),
        ],
      ),
    );
  }
}
