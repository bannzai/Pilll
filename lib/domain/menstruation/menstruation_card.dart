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
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("images/menstruation_icon.svg", width: 20),
                Text("生理予定日",
                    style: TextColorStyle.noshime.merge(FontType.assisting)),
              ],
            ),
            Text(
              DateTimeFormatter.monthAndWeekday(state.scheduleDate),
              style: TextColorStyle.gray.merge(
                FontType.xBigTitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
