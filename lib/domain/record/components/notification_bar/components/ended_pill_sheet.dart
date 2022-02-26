import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class EndedPillSheet extends StatelessWidget {
  final bool isTrial;
  final bool isPremium;

  const EndedPillSheet({
    Key? key,
    required this.isTrial,
    required this.isPremium,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Center(
        child: Column(
          children: [
            Text(
              "ピルシートが終了しました",
              style: FontType.assistingBold.merge(
                TextColorStyle.white,
              ),
            ),
            Text(
              "前回の服用履歴を確認する",
              style: TextStyle(
                color: TextColor.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: FontFamily.japanese,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
