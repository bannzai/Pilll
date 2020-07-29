import 'package:Pilll/theme/color.dart';
import 'package:flutter/material.dart';

class FontFamily {
  static String get standarad => japanese;

  static final String number = "Avenier Next";
  static final String japanese = "Hiragino Kaku Gothic ProN";
}

class FontSize {
  static final double xHuge = 40;
  static final double huge = 32;
  static final double large = 17;
  static final double sLarge = 16;
  static final double normal = 14;
  static final double small = 12;
}

class FontType {
  static final TextStyle largeNumber = TextStyle(
    fontFamily: FontFamily.number,
    fontWeight: FontWeight.w300,
    fontSize: FontSize.huge,
  );
  static final TextStyle title = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w300,
    fontSize: FontSize.large,
  );
  static final TextStyle done = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w600,
    fontSize: FontSize.sLarge,
  );
  static final TextStyle assisting = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w300,
    fontSize: FontSize.normal,
  );
  static final TextStyle assistingBold = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w600,
    fontSize: FontSize.normal,
  );
  static final TextStyle inputNumber = TextStyle(
    fontFamily: FontFamily.number,
    fontWeight: FontWeight.w300,
    fontSize: FontSize.large,
  );
  static final TextStyle description = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w300,
    fontSize: FontSize.small,
  );
}
