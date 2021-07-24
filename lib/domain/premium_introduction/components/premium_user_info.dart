import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class PremiumuserInfoRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "既にプレミアムユーザーです",
      style: TextStyle(
        fontFamily: FontFamily.japanese,
        fontWeight: FontWeight.w700,
        fontSize: 16,
        color: TextColor.main,
      ),
    );
  }
}
