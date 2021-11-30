import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static String toHex({required Color color, bool leadingHashSign = true}) =>
      '${leadingHashSign ? '#' : ''}'
      '${color.alpha.toRadixString(16).padLeft(2, '0')}'
      '${color.red.toRadixString(16).padLeft(2, '0')}'
      '${color.green.toRadixString(16).padLeft(2, '0')}'
      '${color.blue.toRadixString(16).padLeft(2, '0')}';
}

class PilllColors {
  const PilllColors();

  static const Color primary = Color(0xFFE56A45);
  static const Color secondary = Color(0xFF4E6287);
  static const Color calendarHeader = Color(0XFFB9D7F1);
  static const Color accent = Colors.white;
  static const Color pillSheet = Color(0xFFE8EBED);
  static final Color mat = Color(0xFFFAFAFA).withAlpha(80);
  static const Color sunday = Color(0xFFE17F7F);
  static const Color saturday = HexColor.fromHex("7FB9E1");
  static const Color weekday = HexColor.fromHex("7E7E7E");
  static const Color enable = HexColor.fromHex('E56A45');
  static const Color disable = HexColor.fromHex("EAEAEA");
  static const Color divider = HexColor.fromHex("9DAFBD");

  static const Color bottomBar = HexColor.fromHex("FAFAFA");
  static const Color border = HexColor.fromHex("DADADA");
  static const Color unselect = HexColor.fromHex("DFDFDF");
  static const Color background = HexColor.fromHex("F6F9FB");
  static const Color blueBackground = HexColor.fromHex("F1F2F5");

  static const Color blank = Colors.white;
  static const Color black = HexColor.fromHex("333333");
  static const Color red = HexColor.fromHex("EB5757");
  static const Color potti = HexColor.fromHex("7C8E9C");
  static const Color lightGray = HexColor.fromHex("CDCFD1");
  static const Color gray = HexColor.fromHex("BEC0C2");
  static const Color gold = HexColor.fromHex("B29446");

  static const Color menstruation = HexColor.fromHex("E3BFC2");
  static const Color duration = HexColor.fromHex("6A7DA5");
  static const Color overlay = primary.withAlpha(20);

  static const Color modalBackground =
      HexColor.fromHex("333333").withAlpha((255 * 0.7).round());
  static const Color white = Colors.white;

  static Color get disabledSheet => PilllColors.pillSheet;
  static const Color thinSecondary = HexColor.fromHex("4E6287").withAlpha(20);
  static const Color shadow = HexColor.fromHex("212121").withOpacity(0.14);
  static const Color tinBackground =
      HexColor.fromHex("212121").withOpacity(0.08);

  static const Color appleBlack = HexColor.fromHex("231815");
}
