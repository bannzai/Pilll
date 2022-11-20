import 'package:flutter/material.dart';

abstract class PilllColors {
  static const Color primary = Color(0xFF4E6287);
  static const Color secondary = Color(0xFFE56A45);
  static const Color calendarHeader = Color(0XFFB9D7F1);
  static const Color accent = Colors.white;
  static const Color pillSheet = Color(0xFFE8EBED);
  static const Color mat = Color(0xFFE9F0F5);
  static const Color sunday = Color(0xFFE17F7F);
  static const Color saturday = Color(0xFF7FB9E1);
  static const Color weekday = Color(0xFF7E7E7E);
  static const Color enable = Color(0xFFE56A45);
  static const Color disable = Color(0xFFEAEAEA);
  static const Color divider = Color(0xFF9DAFBD);

  static const Color bottomBar = Color(0xFFFAFAFA);
  static const Color border = Color(0xFFDADADA);
  static const Color unselect = Color(0xFFDFDFDF);
  static const Color background = Color(0xFFF6F9FB);
  static const Color blueBackground = Color(0xFFF1F2F5);

  static const Color blank = Colors.white;
  static const Color black = Color(0xFF333333);
  static const Color red = Color(0xFFEB5757);
  static const Color potti = Color(0xFF7C8E9C);
  static const Color lightGray = Color(0xFFCDCFD1);
  static const Color gray = Color(0xFFBEC0C2);
  static const Color gold = Color(0xFFB29446);

  static const Color menstruation = Color(0xFFE3BFC2);
  static const Color duration = Color(0xFF6A7DA5);
  static final Color overlay = secondary.withAlpha(20);

  static final Color modalBackground = const Color(0xFF333333).withAlpha((255 * 0.7).round());
  static const Color white = Colors.white;

  static Color get disabledSheet => PilllColors.pillSheet;
  static final Color thinSecondary = const Color(0xFF4E6287).withAlpha(20);
  static final Color shadow = const Color(0xFF212121).withOpacity(0.14);
  static final Color tinBackground = const Color(0xFF212121).withOpacity(0.08);

  static const Color appleBlack = Color(0xFF231815);
}
