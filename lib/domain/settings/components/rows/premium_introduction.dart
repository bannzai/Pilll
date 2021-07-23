import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_sheet.dart';

class PremiumIntroductionRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showPremiumIntroductionSheet(context);
      },
      title: Text("Pilllプレミアム",
          style: FontType.assisting.merge(TextColorStyle.black)),
    );
  }
}
