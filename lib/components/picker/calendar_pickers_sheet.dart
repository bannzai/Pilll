import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';

class DateRangePickerTheme extends StatelessWidget {
  final Widget child;

  const DateRangePickerTheme({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final appBarTheme = themeData.appBarTheme;

    return Theme(
      data: themeData.copyWith(
        appBarTheme: appBarTheme.copyWith(
          backgroundColor: PilllColors.primary,
        ),
        colorScheme: const ColorScheme.light(
          onPrimary: Colors.white,
          primary: PilllColors.secondary,
        ),
      ),
      child: child,
    );
  }
}
