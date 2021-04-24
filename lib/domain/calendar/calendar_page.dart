import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/calendar/calendar_card.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
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
        top: false,
        child: ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[
            Stack(
              children: [
                Positioned(
                    left: 16,
                    top: 44,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title(),
                        SizedBox(height: 24),
                      ],
                    )),
              ],
            ),
            SizedBox(height: 24),
            Center(
              child: Container(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: CalendarCard(
                    state: CalendarCardState(
                      date: today(),
                      latestPillSheet: state.latestPillSheet,
                      setting: settingEntity,
                      menstruations: state.menstruations,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
