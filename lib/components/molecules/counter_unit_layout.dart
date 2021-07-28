import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class CounterUnitLayout extends StatelessWidget {
  final String title;
  final int number;
  final String unit;

  const CounterUnitLayout({
    Key? key,
    required this.title,
    required this.number,
    required this.unit,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: TextColor.main,
            fontFamily: FontFamily.japanese,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.ideographic,
          children: [
            Text(
              "$number",
              style: TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.number,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              unit,
              style: TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
