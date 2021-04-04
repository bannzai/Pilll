import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/calendar.dart';
import 'package:pilll/domain/calendar/calendar_date_header.dart';
import 'package:pilll/domain/calendar/monthly_calendar_state.dart';
import 'package:pilll/util/datetime/day.dart';

class MenstruationEditPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // final store = useProvider(menstruationEditProvider(entity));
    // final state = useProvider(menstruationEditProvider(entity).state);
    final currentMonth = today();
    final nextMonth = DateTime(today().year, today().month + 1, today().day);
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
              color: PilllColors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0),
              )),
          child: ListView(
            controller: scrollController,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 21.0, left: 16, right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("生理期間を選択・編集",
                        style: FontType.sBigTitle.merge(TextColorStyle.main)),
                    Spacer(),
                    SecondaryButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      text: "保存",
                    )
                  ],
                ),
              ),
              CalendarDateHeader(date: currentMonth),
              Calendar(
                calendarState: CalendarTabState(currentMonth),
                bandModels: [],
                horizontalPadding: 0,
              ),
              CalendarDateHeader(date: nextMonth),
              Calendar(
                calendarState: CalendarTabState(nextMonth),
                bandModels: [],
                horizontalPadding: 0,
              ),
            ],
          ),
        );
      },
    );
  }
}
