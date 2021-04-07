import 'dart:math' as math;
import 'package:pilll/components/molecules/app_card.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/calendar/calendar_card.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/utility.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/store/calendar_page.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
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
    if (settingEntity == null) {
      return ScaffoldIndicator();
    }
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: null,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        top: false,
        child: ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[
            Stack(
              children: [
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(),
                  child: CustomPaint(
                    painter: _HalfCircle(Size(
                        MediaQuery.of(context).size.width + 100,
                        CalendarPageConstants.halfCircleHeight)),
                    size: Size(MediaQuery.of(context).size.width, 220),
                  ),
                ),
                Positioned(
                    left: 16,
                    top: 44,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title(),
                        SizedBox(height: 24),
                        Container(
                          width: MediaQuery.of(context).size.width - 32,
                          height: 111,
                          child: _MenstruationCard(
                            latestPillSheet: state.latestPillSheet,
                            setting: settingEntity,
                            menstruations: state.menstruations,
                          ),
                        ),
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
                    date: today(),
                    latestPillSheet: state.latestPillSheet,
                    setting: settingEntity,
                    menstruations: state.menstruations,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          "こんにちは🍰",
          style: TextColorStyle.noshime.merge(FontType.xBigTitle),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}

// TODO: remote card from Calendar
class _MenstruationCard extends StatelessWidget {
  final PillSheetModel? latestPillSheet;
  final Setting? setting;
  final List<Menstruation> menstruations;

  const _MenstruationCard({
    Key? key,
    required this.latestPillSheet,
    required this.setting,
    required this.menstruations,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("images/menstruation.svg",
                  width: 24, color: PilllColors.red),
              Text("生理予定日",
                  style: TextColorStyle.noshime.merge(FontType.assisting)),
            ],
          ),
          Text(() {
            final latestPillSheet = this.latestPillSheet;
            if (latestPillSheet == null) {
              return "";
            }
            final setting = this.setting;
            if (setting == null) {
              return "";
            }
            final matchedScheduledMenstruation =
                scheduledMenstruationDateRanges(
                        latestPillSheet, setting, menstruations, 12)
                    .where((element) => element.begin.isAfter(today()));

            if (matchedScheduledMenstruation.isNotEmpty) {
              return DateTimeFormatter.monthAndWeekday(
                  matchedScheduledMenstruation.first.begin);
            }
            return "";
          }(), style: TextColorStyle.gray.merge(FontType.xBigTitle)),
        ],
      ),
    );
  }
}

class _HalfCircle extends CustomPainter {
  final Size contentSize;

  _HalfCircle(this.contentSize);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = PilllColors.calendarHeader;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, 0),
        width: this.contentSize.width + this.contentSize.width * 0.5,
        height: this.contentSize.height,
      ),
      math.pi,
      -math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
