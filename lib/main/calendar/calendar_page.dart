import 'package:Pilll/main/calendar/calendar_card.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: PilllColors.background,
        appBar: AppBar(
          title: Text(
            "こんにちは🍰",
            style: TextColorStyle.noshime.merge(FontType.xBigTitle),
          ),
          backgroundColor: PilllColors.background,
        ),
        body: Container(
            child: CalendarCard(
          date: DateTime.now(),
        )));
  }
}
