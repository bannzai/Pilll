import 'package:pilll/components/atoms/color.dart';
import 'package:flutter/material.dart';

class TextColor {
  static Color get standard => black;
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static final Color darkGray = const Color(0xD449454F);
  static const Color gray = const Color(0xFF7E7E7E);
  static const Color lightGray = const Color(0xFFB1B1B1);
  static const Color lightGray2 = const Color(0xFF666666);
  static const Color noshime = const Color(0xFF3D4662);
  static const Color primary = PilllColors.primary;
  static const Color main = const Color(0xD429304D);
  static const Color primaryDarkBlue = const Color(0xFF4E6287);
  static const Color link = primary;
  static const Color danger = PilllColors.red;

  static Color highEmphasis(Color color) => color.withOpacity(0.87);
  static Color mediumEmphasis(Color color) => color.withOpacity(0.6);
  static Color disabled(Color color) => color.withOpacity(0.37);
}

class TextColorStyle {
  static TextStyle get standard => black;
  static const TextStyle black = TextStyle(color: TextColor.black);
  static const TextStyle white = TextStyle(color: TextColor.white);
  static final TextStyle darkGray = TextStyle(color: TextColor.darkGray);
  static const TextStyle gray = TextStyle(color: TextColor.gray);
  static const TextStyle lightGray = TextStyle(color: TextColor.lightGray);
  static const TextStyle lightGray2 = TextStyle(color: TextColor.lightGray2);
  static const TextStyle noshime = TextStyle(color: TextColor.noshime);
  static const TextStyle primary = TextStyle(color: TextColor.primary);
  static const TextStyle main = TextStyle(color: TextColor.main);
  static const TextStyle link = TextStyle(color: TextColor.link);
  static const TextStyle danger = TextStyle(color: TextColor.danger);
}
