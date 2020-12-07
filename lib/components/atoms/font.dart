import 'package:flutter/material.dart';

class FontFamily {
  static String get standarad => japanese;

  static final String number = "Avenier Next";
  static final String japanese = "Noto Sans CJK JP";
  static final String roboto = "Roboto";
}

class FontSize {
  static final double xHuge = 40;
  static final double huge = 32;
  static final double xBig = 24;
  static final double big = 22;
  static final double sBig = 20;
  static final double large = 17;
  static final double sLarge = 16;
  static final double normal = 14;
  static final double small = 12;
  static final double sSmall = 10;
}

class FontType {
  static final TextStyle xHugeNumber = TextStyle(
    fontFamily: FontFamily.number,
    fontWeight: FontWeight.normal,
    fontSize: FontSize.xHuge,
  );
  static final TextStyle largeNumber = TextStyle(
    fontFamily: FontFamily.number,
    fontWeight: FontWeight.w300,
    fontSize: FontSize.huge,
  );
  static final TextStyle title = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w600,
    fontSize: FontSize.large,
  );
  static final TextStyle subTitle = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w600,
    fontSize: FontSize.sLarge,
  );
  static final TextStyle xBigTitle = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w600,
    fontSize: FontSize.xBig,
  );
  static final TextStyle xBigNumber = TextStyle(
    fontFamily: FontFamily.number,
    fontWeight: FontWeight.w300,
    fontSize: FontSize.xBig,
  );
  static final TextStyle sBigTitle = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w600,
    fontSize: FontSize.sBig,
  );
  static final TextStyle cardHeader = TextStyle(
    fontFamily: FontFamily.number,
    fontWeight: FontWeight.w600,
    fontSize: FontSize.big,
  );
  static final TextStyle thinTitle = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w300,
    fontSize: FontSize.sLarge,
  );
  static final TextStyle done = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w600,
    fontSize: FontSize.sLarge,
  );
  static final TextStyle close = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w600,
    fontSize: FontSize.normal,
  );
  static final TextStyle componentTitle = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w300,
    fontSize: FontSize.sLarge,
  );
  static final TextStyle row = TextStyle(
    fontFamily: FontFamily.roboto,
    fontWeight: FontWeight.w300,
    fontSize: FontSize.normal,
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
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w700,
    fontSize: FontSize.sLarge,
  );
  static final TextStyle description = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w300,
    fontSize: FontSize.small,
  );
  static final TextStyle sSmallTitle = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w600,
    fontSize: FontSize.sSmall,
  );
}
