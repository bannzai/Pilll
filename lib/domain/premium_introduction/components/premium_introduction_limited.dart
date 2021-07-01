import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/datetime/timer.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

class PremiumIntroductionLimited extends HookWidget {
  final DateTime trialDeadlineDate;
  DateTime get discountedPriceDeadline =>
      trialDeadlineDate.add(Duration(hours: 48));

  const PremiumIntroductionLimited({Key? key, required this.trialDeadlineDate})
      : super(key: key);
  Widget build(BuildContext context) {
    final timer = useProvider(timerStoreProvider);
    timer.fire(now());
    final timerState = useProvider(timerStoreProvider.state);
    final diff = discountedPriceDeadline.difference(timerState);
    final String countdown;
    if (diff.inSeconds <= 0) {
      countdown = "00:00:00";
    } else {
      countdown =
          DateTimeFormatter.clock(diff.inHours, diff.inMinutes, diff.inSeconds);
    }
    return Container(
      padding: EdgeInsets.only(left: 40, right: 40),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "今だけ！リリース記念価格",
            textAlign: TextAlign.center,
            style: TextColorStyle.main.merge(
              TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: FontFamily.japanese,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(
            countdown,
            style: TextStyle(
              color: TextColor.main,
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "通常 月額プラン",
            textAlign: TextAlign.center,
            style: TextColorStyle.black.merge(
              TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                fontFamily: FontFamily.japanese,
              ),
            ),
          ),
          SizedBox(height: 4),
          Stack(
            children: [
              Text(
                "¥480",
                textAlign: TextAlign.center,
                style: TextColorStyle.main.merge(
                  TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                    fontFamily: FontFamily.japanese,
                  ),
                ),
              ),
              Positioned(
                left: 30,
                child: SvgPicture.asset("images/strikethrough.svg"),
              ),
            ],
          ),
          SizedBox(height: 8),
          SvgPicture.asset("images/arrow_down.svg"),
        ],
      ),
    );
  }
}
