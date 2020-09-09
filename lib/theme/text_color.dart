import 'package:Pilll/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextColor {
  static Color get standard => black;
  static final Color black = Colors.black;
  static final Color white = Colors.white;
  static final Color gray = HexColor.fromHex("7E7E7E");
  static final Color lightGray = HexColor.fromHex("CDCFD1");
  static final Color noshime = HexColor.fromHex("29304D").withAlpha(87);
}

class TextColorStyle {
  static TextStyle get standard => black;
  static final TextStyle black = TextStyle(color: TextColor.black);
  static final TextStyle white = TextStyle(color: TextColor.white);
  static final TextStyle gray = TextStyle(color: TextColor.gray);
  static final TextStyle lightGray = TextStyle(color: TextColor.lightGray);
  static final TextStyle noshime = TextStyle(color: TextColor.noshime);
}
