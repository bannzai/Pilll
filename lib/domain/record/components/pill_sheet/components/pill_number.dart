import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

class PlainPillNumber extends StatelessWidget {
  final int pillNumber;

  const PlainPillNumber({Key? key, required this.pillNumber}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      "$pillNumber",
      style: FontType.smallTitle.merge(TextStyle(color: PilllColors.weekday)),
      textScaleFactor: 1,
    );
  }
}

class PlainPillDate extends StatelessWidget {
  final DateTime date;

  const PlainPillDate({Key? key, required this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      DateTimeFormatter.monthAndDay(date),
      style: FontType.smallTitle.merge(TextStyle(color: PilllColors.weekday)),
      textScaleFactor: 1,
    );
  }
}

class MenstruationPillNumber extends StatelessWidget {
  final int pillNumber;

  const MenstruationPillNumber({Key? key, required this.pillNumber})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      "$pillNumber",
      style: FontType.smallTitle.merge(TextStyle(color: PilllColors.primary)),
      textScaleFactor: 1,
    );
  }
}

class MenstruationPillDate extends StatelessWidget {
  final DateTime date;
  const MenstruationPillDate({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      DateTimeFormatter.monthAndDay(date),
      style: FontType.smallTitle.merge(TextStyle(color: PilllColors.primary)),
      textScaleFactor: 1,
    );
  }
}
