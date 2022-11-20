import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

class CalendarPageTitle extends StatelessWidget {
  final DateTime displayedMonth;
  final ValueNotifier<int> page;
  final PageController pageController;

  const CalendarPageTitle({
    Key? key,
    required this.displayedMonth,
    required this.page,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: SvgPicture.asset("images/arrow_left.svg"),
          onPressed: () {
            final previousMonthIndex = page.value - 1;

            analytics.logEvent(name: "pressed_previous_month", parameters: {"current_index": page.value, "previous_index": previousMonthIndex});

            pageController.jumpToPage(previousMonthIndex);
            page.value = previousMonthIndex;
          },
        ),
        Text(
          _displayMonthString,
          style: TextColorStyle.main.merge(const TextStyle(
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          )),
        ),
        IconButton(
          icon: SvgPicture.asset("images/arrow_right.svg"),
          onPressed: () {
            final nextMonthIndex = page.value + 1;

            analytics.logEvent(name: "pressed_next_month", parameters: {"current_index": page.value, "next_index": nextMonthIndex});

            pageController.jumpToPage(nextMonthIndex);
            page.value = nextMonthIndex;
          },
        ),
      ],
    );
  }

  String get _displayMonthString => DateTimeFormatter.yearAndMonth(displayedMonth);
}
