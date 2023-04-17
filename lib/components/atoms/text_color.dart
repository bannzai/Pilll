import 'package:pilll/components/atoms/color.dart';
import 'package:flutter/material.dart';

abstract class TextColor {
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color darkGray = Color(0xD449454F);
  static const Color gray = Color(0xFF7E7E7E);
  static const Color lightGray = Color(0xFFB1B1B1);
  static const Color lightGray2 = Color(0xFF666666);
  static const Color noshime = Color(0xFF3D4662);
  static const Color primary = PilllColors.secondary;
  static const Color main = Color(0xD429304D);
  static const Color primaryDarkBlue = Color(0xFF4E6287);
  static const Color link = primary;
  static const Color danger = PilllColors.red;
  static const Color discount = Color(0xFFB00020);

  static Color highEmphasis(Color color) => color.withOpacity(0.87);
  static Color mediumEmphasis(Color color) => color.withOpacity(0.6);
  static Color disabled(Color color) => color.withOpacity(0.37);
}
