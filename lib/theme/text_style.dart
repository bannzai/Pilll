import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:flutter/widgets.dart';

class TextStyles {
  static final TextStyle title = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w600,
    fontSize: 18,
    color: PilllColors.blackText,
  );
  static final TextStyle subTitle = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.normal,
    fontSize: 17,
    color: PilllColors.plainText,
  );
  static final TextStyle question = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: PilllColors.blackText,
  );
  static final TextStyle assisting = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w300,
    fontSize: 14,
    color: PilllColors.plainText,
  );
  static final TextStyle input = TextStyle(
    fontFamily: FontFamily.number,
    fontWeight: FontWeight.normal,
    fontSize: 17,
    color: PilllColors.plainText,
  );
  static final TextStyle list = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w300,
    fontSize: 12,
    color: PilllColors.blackText,
  );
  static final TextStyle description = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w300,
    fontSize: 12,
    color: PilllColors.blackText,
  );
  static final TextStyle done = TextStyle(
    fontFamily: FontFamily.japanese,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: PilllColors.whiteText,
  );
  static final TextStyle largeNumber = TextStyle(
    fontFamily: FontFamily.number,
    fontWeight: FontWeight.normal,
    fontSize: 32,
    color: PilllColors.blackText,
  );
}
