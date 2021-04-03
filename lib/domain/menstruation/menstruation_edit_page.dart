import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/components/atoms/color.dart';
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
              CalendarDateHeader(date: currentMonth),
              Calendar(
                calendarState: MonthlyCalendarState(currentMonth),
                bandModels: [],
                horizontalPadding: 0,
              ),
              CalendarDateHeader(date: nextMonth),
              Calendar(
                calendarState: MonthlyCalendarState(nextMonth),
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
