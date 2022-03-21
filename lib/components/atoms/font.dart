import 'package:flutter/material.dart';

class FontFamily {
  static String get standarad => japanese;

  static const String number = "Avenir Next";
  static const String alphabet = "Avenir Next";
  static const String japanese = "Noto Sans CJK JP";
  static const String roboto = "Roboto";
}

class FontSize {
  static const double xHuge = 40;
  static const double huge = 34;
  static const double xBig = 24;
  static const double big = 22;
  static const double sBig = 20;
  static const double large = 17;
  static const double sLarge = 16;
  static const double normal = 14;
  static const double small = 12;
  static const double sSmall = 10;
}

class FontType {
  static const TextStyle xHugeNumber = TextStyle(
    fontFamily: FontFamily.number,
    fontWeight: FontWeight.w500,
    fontSize: FontSize.xHuge,
  );
  static const TextStyle largeNumber = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w500,
    fontSize: FontSize.huge,
  );
  static const TextStyle title = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w600,
    fontSize: FontSize.large,
  );
  static const TextStyle subTitle = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w600,
    fontSize: FontSize.sLarge,
  );
  static const TextStyle xBigTitle = TextStyle(
    fontFamily: FontFamily.number,
    fontWeight: FontWeight.w500,
    fontSize: FontSize.xBig,
  );
  static const TextStyle xBigNumber = TextStyle(
    fontFamily: FontFamily.number,
    fontWeight: FontWeight.w600,
    fontSize: FontSize.xBig,
  );
  static const TextStyle sBigTitle = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w500,
    fontSize: FontSize.sBig,
  );
  static const TextStyle cardHeader = TextStyle(
    fontFamily: FontFamily.number,
    fontWeight: FontWeight.w600,
    fontSize: FontSize.big,
  );
  static const TextStyle thinTitle = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w300,
    fontSize: FontSize.sLarge,
  );
  static const TextStyle done = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w600,
    fontSize: FontSize.sLarge,
  );
  static const TextStyle close = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w600,
    fontSize: FontSize.normal,
  );
  static const TextStyle componentTitle = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w300,
    fontSize: FontSize.sLarge,
  );
  static const TextStyle gridElement = TextStyle(
    fontFamily: FontFamily.number,
    fontWeight: FontWeight.w600,
    fontSize: FontSize.sLarge,
  );

  static const TextStyle helpRow = TextStyle(
    fontFamily: FontFamily.roboto,
    fontWeight: FontWeight.w400,
    fontSize: FontSize.normal,
  );
  static const TextStyle listRow = TextStyle(
    fontFamily: FontFamily.roboto,
    fontWeight: FontWeight.w300,
    fontSize: FontSize.sLarge,
  );
  static const TextStyle assisting = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w300,
    fontSize: FontSize.normal,
  );
  static const TextStyle assistingBold = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w600,
    fontSize: FontSize.normal,
  );
  static const TextStyle inputNumber = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w700,
    fontSize: FontSize.sLarge,
  );
  static const TextStyle description = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w400,
    fontSize: FontSize.small,
  );
  static const TextStyle descriptionBold = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w700,
    fontSize: FontSize.small,
  );
  static const TextStyle smallTitle = TextStyle(
    fontFamily: FontFamily.number,
    fontWeight: FontWeight.w500,
    fontSize: FontSize.small,
  );
  static const TextStyle sSmallTitle = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w600,
    fontSize: FontSize.sSmall,
  );
  static const TextStyle sSmallNumber = TextStyle(
    fontFamily: FontFamily.number,
    fontWeight: FontWeight.w600,
    fontSize: FontSize.sSmall,
  );
  static const TextStyle sSmallSentence = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w300,
    fontSize: FontSize.sSmall,
  );
}
