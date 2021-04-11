import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/molecules/app_card.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class MenstruationCard2State {
  final String prefix;
  final Menstruation menstruation;

  MenstruationCard2State({required this.menstruation, required this.prefix});

  String get dateRange {
    return DateTimeFormatter.monthAndDay(menstruation.beginDate) +
        " - " +
        DateTimeFormatter.monthAndDay(menstruation.endDate);
  }
}

class MenstruationCard2 extends StatelessWidget {
  final MenstruationCard2State state;
  final Function(MenstruationCard2State) onTap;

  MenstruationCard2(this.state, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      height: 72,
      child: AppCard(
        child: Padding(
          padding: EdgeInsets.only(left: 36, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                "images/menstruation.svg",
                width: 24,
                color: PilllColors.red,
              ),
              Text(state.prefix + "の生理",
                  style: TextColorStyle.noshime.merge(FontType.assisting)),
              Spacer(),
              Text(
                state.dateRange,
                style: TextColorStyle.gray.merge(
                  FontType.xBigTitle,
                ),
              ),
              Spacer(),
              AppBarTextActionButton(
                text: "編集",
                onPressed: () => onTap(state),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
