import 'package:pilll/components/atoms/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextColor {
  static Color get standard => black;
  static final Color black = Colors.black;
  static final Color white = Colors.white;
  static final Color darkGray = Color(0xFF000000).withAlpha(153);
  static final Color gray = Color(0xFF7E7E7E);
  static final Color lightGray = Color(0xFFB1B1B1);
  static final Color lightGray2 = Color(0xFF666666);
  static final Color noshime = Color(0xFF3D4662);
  static final Color primary = PilllColors.primary;
  static final Color main = Color(0xFF29304D);
  static final Color link = primary;
  static final Color danger = PilllColors.red;
}

class TextColorStyle {
  static TextStyle get standard => black;
  static final TextStyle black = TextStyle(color: TextColor.black);
  static final TextStyle white = TextStyle(color: TextColor.white);
  static final TextStyle darkGray = TextStyle(color: TextColor.darkGray);
  static final TextStyle gray = TextStyle(color: TextColor.gray);
  static final TextStyle lightGray = TextStyle(color: TextColor.lightGray);
  static final TextStyle lightGray2 = TextStyle(color: TextColor.lightGray2);
  static final TextStyle noshime = TextStyle(color: TextColor.noshime);
  static final TextStyle primary = TextStyle(color: TextColor.primary);
  static final TextStyle main = TextStyle(color: TextColor.main);
  static final TextStyle link = TextStyle(color: TextColor.link);
  static final TextStyle danger = TextStyle(color: TextColor.danger);
}
