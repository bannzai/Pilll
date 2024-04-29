import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class Time extends StatelessWidget {
  const Time({
    super.key,
    required this.time,
  });

  final String time;

  @override
  Widget build(BuildContext context) {
    return Text(
      time,
      style: const TextStyle(
        decoration: TextDecoration.underline,
        letterSpacing: 1.5,
        color: TextColor.main,
        fontSize: 15,
        fontFamily: FontFamily.number,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.start,
    );
  }
}
