import 'dart:math' as math;

import 'package:Pilll/main/calendar/calendar_card.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "こんにちは🍰",
              style: TextColorStyle.noshime.merge(FontType.xBigTitle),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: <Widget>[
          CustomPaint(
            painter:
                _HalfCircle(Size(MediaQuery.of(context).size.width + 100, 250)),
            size: Size(MediaQuery.of(context).size.width, 125),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 32,
              child: CalendarCard(
                date: DateTime.now(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// This is the Painter class
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
