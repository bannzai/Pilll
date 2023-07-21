import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';

class PlainPillNumber extends StatelessWidget {
  final String text;

  const PlainPillNumber({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: FontFamily.number,
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ).merge(const TextStyle(color: PilllColors.weekday)),
      textScaleFactor: 1,
    );
  }
}

class MenstruationPillNumber extends StatelessWidget {
  final String text;

  const MenstruationPillNumber({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: FontFamily.number,
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ).merge(const TextStyle(color: PilllColors.secondary)),
      textScaleFactor: 1,
    );
  }
}
