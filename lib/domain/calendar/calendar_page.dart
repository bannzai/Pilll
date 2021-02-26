import 'dart:math' as math;

import 'package:Pilll/components/molecules/app_card.dart';
import 'package:Pilll/domain/calendar/calendar_card.dart';
import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/components/atoms/font.dart';
import 'package:Pilll/components/atoms/text_color.dart';
import 'package:Pilll/domain/calendar/utility.dart';
import 'package:Pilll/store/pill_sheet.dart';
import 'package:Pilll/store/setting.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Pilll/util/datetime/day.dart' as utility;
import 'package:hooks_riverpod/all.dart';

abstract class CalendarPageConstants {
  static final double halfCircleHeight = 300;
}

class CalendarPage extends StatelessWidget {
  DateTime get today => utility.today();
  @override
  Widget build(BuildContext context) {
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
                CustomPaint(
                  painter: _HalfCircle(Size(
                      MediaQuery.of(context).size.width + 100,
                      CalendarPageConstants.halfCircleHeight)),
                  size: Size(MediaQuery.of(context).size.width, 220),
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
                          child: _menstruationCard(),
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
                    date: today,
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

  Widget _menstruationCard() {
    return MenstruationCard();
  }
}

class MenstruationCard extends HookWidget {
  const MenstruationCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pillSheetState = useProvider(pillSheetStoreProvider.state);
    final settingState = useProvider(settingStoreProvider.state);
    return AppCard(
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
          Text(() {
            if (pillSheetState.latestPillSheet == null) {
              return "";
            }

            for (int i = 0; i < 12; i += 1) {
              final begin = menstruationDateRange(
                      pillSheetState.latestPillSheet, settingState.entity, i)
                  .begin;
              if (begin.isAfter(utility.today())) {
                return DateTimeFormatter.monthAndWeekday(begin);
              }
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
