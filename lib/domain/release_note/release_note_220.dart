import 'package:Pilll/components/atoms/buttons.dart';
import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/components/atoms/font.dart';
import 'package:Pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';

class ReleaseNote220 extends StatelessWidget {
  const ReleaseNote220({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
        backgroundColor: PilllColors.white,
      ),
      body: Center(
        child: Container(
          width: 304,
          height: 302,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "新機能・機能改善のお知らせ✨",
                style: FontType.sBigTitle.merge(TextColorStyle.main),
              ),
              SizedBox(height: 32),
              Text(
                "28錠(すべて実薬)タイプを追加しました！",
                style: FontType.assistingBold.merge(TextColorStyle.main),
              ),
              SizedBox(height: 20),
              Text(
                "ヤーズフレックスなど、28錠偽薬なしをお使いの方、ご活用ください🙌",
                style: FontType.assistingBold.merge(TextColorStyle.main),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Container(
                    width: 230,
                    child: PrimaryButton(
                        onPressed: () => print("TODO"), text: "設定を見てみる")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
