import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/molecules/app_card.dart';
import 'package:pilll/domain/menstruation/menstruation_card_state.codegen.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class MenstruationCard extends StatelessWidget {
  final MenstruationCardState state;

  const MenstruationCard(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 111,
      child: AppCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "images/menstruation.svg",
                      width: 24,
                      color: PilllColors.red,
                    ),
                    Text(
                      state.title,
                      style: const TextStyle(
                        fontFamily: FontFamily.japanese,
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        color: TextColor.noshime,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Text(
                  DateTimeFormatter.monthAndWeekday(state.scheduleDate),
                  style: const TextStyle(color: TextColor.gray, fontSize: 20, fontWeight: FontWeight.w500, fontFamily: FontFamily.japanese),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.only(left: 32, right: 32, top: 2, bottom: 2),
              decoration: BoxDecoration(
                color: PilllColors.primary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(state.countdownString,
                  style: const TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: TextColor.white,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
