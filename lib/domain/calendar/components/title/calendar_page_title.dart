import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/domain/calendar/calendar_page_index_state_notifier.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/calendar_page_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

class CalendarPageTitle extends HookConsumerWidget {
  final DateTime displayedMonth;
  final int page;
  final PageController pageController;

  const CalendarPageTitle({
    Key? key,
    required this.displayedMonth,
    required this.page,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarPageIndexStateNotifier = ref.watch(calendarPageIndexStateNotifierProvider.notifier);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: SvgPicture.asset("images/arrow_left.svg"),
          onPressed: () {
            final previousMonthIndex = page - 1;

            analytics.logEvent(name: "pressed_previous_month", parameters: {"current_index": page, "previous_index": previousMonthIndex});

            pageController.jumpToPage(previousMonthIndex);
            calendarPageIndexStateNotifier.set(previousMonthIndex);
          },
        ),
        Text(
          _displayMonthString,
          style: TextColorStyle.main.merge(FontType.subTitle),
        ),
        IconButton(
          icon: SvgPicture.asset("images/arrow_right.svg"),
          onPressed: () {
            final nextMonthIndex = page + 1;

            analytics.logEvent(name: "pressed_next_month", parameters: {"current_index": state.currentCalendarIndex, "next_index": nextMonthIndex});

            pageController.jumpToPage(nextMonthIndex);
            calendarPageIndexStateNotifier.set(nextMonthIndex);
          },
        ),
      ],
    );
  }

  String get _displayMonthString => DateTimeFormatter.yearAndMonth(displayedMonth);
}
