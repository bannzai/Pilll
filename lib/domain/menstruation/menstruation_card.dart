import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/molecules/app_card.dart';
import 'package:pilll/domain/menstruation/menstruation_card_state.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class MenstruationCard extends StatelessWidget {
  final MenstruationCardState state;

  MenstruationCard(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
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
                    Text("生理予定日",
                        style:
                            TextColorStyle.noshime.merge(FontType.assisting)),
                  ],
                ),
                SizedBox(width: 12),
                Text(
                  DateTimeFormatter.monthAndWeekday(state.scheduleDate),
                  style: TextColorStyle.gray.merge(
                    FontType.xBigTitle,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.only(left: 32, right: 32, top: 2, bottom: 2),
              decoration: BoxDecoration(
                color: PilllColors.secondary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(state.countdownString,
                  style: TextColorStyle.white.merge(FontType.assistingBold)),
            ),
          ],
        ),
      ),
    );
  }
}
