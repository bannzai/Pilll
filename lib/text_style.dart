import 'package:Pilll/color.dart';
import 'package:Pilll/font.dart';
import 'package:flutter/widgets.dart';

class TextStyles {
  static final TextStyle title = TextStyle(
      fontFamily: PilllFontFamily.japanese,
      fontWeight: FontWeight.w600,
      fontSize: 18,
      color: PilllColors.blackText);
  static final TextStyle subTitle = TextStyle(
    fontFamily: PilllFontFamily.japanese,
    fontWeight: FontWeight.normal,
    fontSize: 17,
    color: PilllColors.plainText,
  );
  static final TextStyle list = TextStyle(
    fontFamily: PilllFontFamily.japanese,
    fontWeight: FontWeight.normal,
    fontSize: 12,
    color: PilllColors.blackText,
  );
  static final TextStyle done = TextStyle(
    fontFamily: PilllFontFamily.japanese,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: PilllColors.whiteText,
  );
}
