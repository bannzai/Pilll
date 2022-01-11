import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class EffectivePillNumber extends StatelessWidget {
  const EffectivePillNumber({
    Key? key,
    required this.effectivePillNumber,
  }) : super(key: key);

  final String effectivePillNumber;

  @override
  Widget build(BuildContext context) {
    return Text(
      "$effectivePillNumber",
      style: TextStyle(
        color: TextColor.main,
        fontFamily: FontFamily.japanese,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.start,
    );
  }
}
