import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_page.dart';

class PremiumIntroductionRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          PremiumIntroductionPageRoutes.route(),
        );
      },
      leading: Image.asset("images/pilll_icon.png", width: 32, height: 32),
      title: Align(
        alignment: Alignment(-1.1, 0),
        child: Text("Pilllプレミアム",
            style: FontType.assisting.merge(TextColorStyle.black)),
      ),
    );
  }
}
