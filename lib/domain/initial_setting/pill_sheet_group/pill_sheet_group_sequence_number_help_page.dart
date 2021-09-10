import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class PillSheetGroupSequenceNumberHelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      content: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16),
            Text(
              "2枚目以降のピル番号が\n連番表示されます",
              style: TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            SvgPicture.asset("images/pill_sheet_group_explain.svg"),
            SizedBox(height: 24),
            Text(
              "ヤーズフレックスやジェミーナなど\n連続服用する方におすすめの設定です",
              style: TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            SecondaryButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: "閉じる",
            ),
          ],
        ),
      ),
    );
  }
}

showPillSheetGroupSequenceNumberHelpPage(
  BuildContext context,
) {
  showDialog(
    context: context,
    builder: (context) => PillSheetGroupSequenceNumberHelpPage(),
  );
}
