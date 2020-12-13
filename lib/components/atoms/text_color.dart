import 'package:Pilll/components/atoms/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextColor {
  static Color get standard => black;
  static final Color black = Colors.black;
  static final Color white = Colors.white;
  static final Color darkGray = HexColor.fromHex("000000").withAlpha(96);
  static final Color gray = HexColor.fromHex("7E7E7E");
  static final Color lightGray = HexColor.fromHex("CDCFD1");
  static final Color lightGray2 = HexColor.fromHex("666666");
  static final Color noshime = HexColor.fromHex("3D4662");
  static final Color primary = PilllColors.primary;
  static final Color main = HexColor.fromHex("454B64");
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
}
