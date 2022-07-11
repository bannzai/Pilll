import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:flutter/material.dart';

abstract class ButtonTextStyle {
  static const TextStyle main = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w700,
    fontSize: FontSize.sLarge,
    color: PilllColors.white,
  );
}
