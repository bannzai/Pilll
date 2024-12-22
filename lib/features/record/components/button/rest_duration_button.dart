import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/localizations/l.dart';

class RestDurationButton extends StatelessWidget {
  const RestDurationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 44,
      child: TextButton(
        style: TextButton.styleFrom(backgroundColor: AppColors.disable),
        onPressed: null,
        child: Text(
          L.pauseTaking,
          style: const TextStyle(
            color: TextColor.lightGray,
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
