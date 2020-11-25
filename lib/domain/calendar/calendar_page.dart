import 'dart:math' as math;

import 'package:Pilll/domain/calendar/calendar_card.dart';
import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/components/atoms/font.dart';
import 'package:Pilll/components/atoms/text_color.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Pilll/util/datetime/day.dart' as utility;

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
      body: ListView(
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
                child: _title(),
              ),
              Positioned(
                left: 16,
                top: 85,
                width: MediaQuery.of(context).size.width - 32,
                height: 111,
                child: _menstruationCard(today),
              ),
            ],
          ),
          Center(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: CalendarCard(
                  date: today,
                ),
              ),
            ),
          ),
        ],
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

  Widget _menstruationCard(DateTime date) {
    return Card(
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
          Text(DateTimeFormatter.monthAndWeekday(date),
              style: TextColorStyle.gray.merge(FontType.xBigTitle)),
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
    Paint paint = Paint()..color = PilllColors.secondary;
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
