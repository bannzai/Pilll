import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class PromoteAddingPillSheet extends StatelessWidget {
  const PromoteAddingPillSheet({
    Key? key,
    required this.premiumTrialLimit,
  }) : super(key: key);

  final String premiumTrialLimit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Center(
        child: Text("ピルシートが終了しました",
            style: FontType.assistingBold.merge(TextColorStyle.white)),
      ),
    );
  }
}
