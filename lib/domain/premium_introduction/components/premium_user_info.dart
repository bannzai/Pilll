import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class PremiumuserInfoRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "あなたは\vプレミアムメンバーです",
          style: TextStyle(
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: TextColor.main,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32),
        SvgPicture.asset("images/jewel.svg"),
        SizedBox(height: 24),
        Text(
          "ご利用ありがとうございます。\nお陰様でPilllの運営を継続できています。",
          style: TextStyle(
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: TextColor.main,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
