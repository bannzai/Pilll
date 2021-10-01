import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class EndedPillSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: Center(
        child: Text("ピルシートが終了しました",
            style: FontType.assistingBold.merge(TextColorStyle.white)),
      ),
    );
  }
}
