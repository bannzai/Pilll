import 'package:Pilll/components/atoms/buttons.dart';
import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/components/atoms/font.dart';
import 'package:Pilll/components/atoms/text_color.dart';
import 'package:Pilll/domain/home/home_page.dart';
import 'package:flutter/material.dart';

class ReleaseNote220 extends StatelessWidget {
  const ReleaseNote220({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: PilllColors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
          width: 304,
          height: 302,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "新機能・機能改善のお知らせ✨",
                style: FontType.subTitle.merge(TextColorStyle.black),
              ),
              SizedBox(height: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "28錠(すべて実薬)タイプを追加しました！",
                    style: FontType.assisting.merge(TextColorStyle.main),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "ヤーズフレックスなど、28錠偽薬なしをお使いの方、ご活用ください🙌",
                    style: FontType.assisting.merge(TextColorStyle.main),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Container(
                    width: 230,
                    child: SecondaryButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          homeKey.currentState
                              ?.selectTab(HomePageTabType.setting);
                        },
                        text: "設定を見てみる")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
