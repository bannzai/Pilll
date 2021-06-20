import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class PremiumCompleteDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(24, 48, 24, 24),
      content: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Pilllプレミアム登録完了",
              style: TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            SvgPicture.asset("images/jewel.svg"),
            SizedBox(height: 24),
            Text(
              "ご登録ありがとうございます。\nすべての機能が使えるようになりました！",
              style: TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            PrimaryButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: "OK",
            ),
          ],
        ),
      ),
    );
  }
}
