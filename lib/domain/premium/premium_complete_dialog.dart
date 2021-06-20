import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class PremiumCompleteDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        decoration: BoxDecoration(
          color: PilllColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: PilllColors.shadow,
              blurRadius: 6.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              "Pilllプレミアム登録完了",
              style: TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            SvgPicture.asset("images/jewel.svg"),
            Text(
              "ご登録ありがとうございます。\nすべての機能が使えるようになりました！",
              style: TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
