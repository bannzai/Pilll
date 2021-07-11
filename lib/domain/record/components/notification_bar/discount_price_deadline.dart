import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/premium_introduction/util/discount_deadline.dart';

class DiscountPriceDeadline extends HookWidget {
  final DateTime trialDeadlineDate;

  DiscountPriceDeadline(this.trialDeadlineDate);
  @override
  Widget build(BuildContext context) {
    final difference =
        useProvider(durationToDiscountPriceDeadline(trialDeadlineDate));
    if (difference.inSeconds <= 0) {
      return Container();
    }
    final countdown = discountPriceDeadlineCountdownString(difference);
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: Center(
        child: Text(
          "トライアル期間が終了しました\n $countdown 内に購入すると記念価格で購入できます",
          style: FontType.assistingBold.merge(TextColorStyle.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
