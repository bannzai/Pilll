import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/calendar/calendar.dart';
import 'package:pilll/domain/calendar/calendar_card.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/calendar_help.dart';
import 'package:pilll/domain/calendar/calendar_weekday_line.dart';
import 'package:pilll/domain/calendar/monthly_calendar_state.dart';
import 'package:pilll/entity/diary.dart';
import 'package:pilll/store/calendar_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class CalendarPageConstants {
  static final double halfCircleHeight = 300;
}

class CalendarPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useProvider(calendarPageStateProvider.state);
    final settingEntity = state.setting;
    if (state.shouldShowIndicator) {
      return ScaffoldIndicator();
    }
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: AppBarTextActionButton(onPressed: () {}, text: "今日"),
        actions: [
          IconButton(
            icon: SvgPicture.asset("images/help.svg"),
            onPressed: () {
              analytics.logEvent(name: "pressed_calendar_help");
              showDialog(
                  context: context,
                  builder: (_) {
                    return CalendarHelpPage();
                  });
            },
          ),
        ],
        title: Text(
          "2020年8月",
          style: TextColorStyle.main.merge(FontType.sBigTitle),
        ),
        backgroundColor: PilllColors.white,
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Center(
              child: Container(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: _calendar(
                    state: CalendarCardState(
                      date: today(),
                      latestPillSheet: state.latestPillSheet,
                      setting: settingEntity,
                      menstruations: state.menstruations,
                    ),
                    onTap: (date, diaries) {
                      analytics.logEvent(
                          name: "did_select_day_tile_on_calendar_card");
                      transitionToPostDiary(context, date, diaries);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _calendar({
    required CalendarCardState state,
    required Function(DateTime, List<Diary>) onTap,
  }) {
    return Calendar(
      calendarState: CalendarTabState(state.date),
      bandModels: state.bands(),
      onTap: onTap,
      horizontalPadding: 16,
    );
  }
}
