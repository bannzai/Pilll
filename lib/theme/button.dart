import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:flutter/material.dart';

abstract class ButtonTextStyle {
  static final TextStyle alertCancel = ButtonTextStyle.alertDone;
  static final TextStyle alertDone = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w600,
    fontSize: FontSize.normal,
    color: PilllColors.primary,
  );
}
