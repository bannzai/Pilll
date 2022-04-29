import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/domain/calendar/calendar_page_state.codegen.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/calendar_page_store.dart';
import 'package:flutter/material.dart';

class CalendarPageTitle extends StatelessWidget {
  const CalendarPageTitle({
    Key? key,
    required this.state,
    required this.pageController,
    required this.store,
  }) : super(key: key);

  final CalendarPageState state;
  final PageController pageController;
  final CalendarPageStateStore store;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: SvgPicture.asset("images/arrow_left.svg"),
          onPressed: () {
            final previousMonthIndex = state.currentCalendarIndex - 1;
            pageController.jumpToPage(previousMonthIndex);
            store.updateCurrentCalendarIndex(previousMonthIndex);
            analytics.logEvent(name: "pressed_previous_month", parameters: {
              "current_index": state.currentCalendarIndex,
              "previous_index": previousMonthIndex
            });
          },
        ),
        Text(
          state.displayMonthString,
          style: TextColorStyle.main.merge(FontType.subTitle),
        ),
        IconButton(
          icon: SvgPicture.asset("images/arrow_right.svg"),
          onPressed: () {
            final nextMonthIndex = state.currentCalendarIndex + 1;
            pageController.jumpToPage(nextMonthIndex);
            store.updateCurrentCalendarIndex(nextMonthIndex);
            analytics.logEvent(name: "pressed_next_month", parameters: {
              "current_index": state.currentCalendarIndex,
              "next_index": nextMonthIndex
            });
          },
        ),
      ],
    );
  }
}
