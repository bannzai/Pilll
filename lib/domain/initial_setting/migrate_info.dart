import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/components/atoms/font.dart';
import 'package:Pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';

class MigrateInfo extends StatelessWidget {
  final VoidCallback onClose;

  const MigrateInfo({Key key, @required this.onClose}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: PilllColors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 272,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "お知らせとお詫び",
                  style: FontType.sBigTitle.merge(TextColorStyle.main),
                ),
                SizedBox(height: 32),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "今回のアップデートにより大型リニューアル前のアプリでピルシートを服用していたときのデータを参照できるようにしました。",
                        style: FontType.assisting.merge(TextColorStyle.main),
                      ),
                      TextSpan(
                        text: "設定 > 大型アップデート前の情報 ",
                        style:
                            FontType.assistingBold.merge(TextColorStyle.main),
                      ),
                      TextSpan(
                        text: "から表示されます。",
                        style: FontType.assisting.merge(TextColorStyle.main),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "先日、Pilllはより便利になる準備のためにアプリを作り直して大型アップデートを行いました。アップデート後に一部のユーザーの方から何人かのユーザーの方から「アップデート前のデータが分からなくなり、今飲んでいるピル番号が把握できなくなった」と。お問い合わせをいただきました。作り直しの過程で自動でピル番号含めた設定情報を自動的に移行することが困難になり、そしてこのような事態になってしまいました。",
                  style: FontType.assistingBold.merge(TextColorStyle.main),
                ),
                SizedBox(height: 10),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "同じようにお困りの方はこちらの表示を参考にしてピルシートの番号を調整していただくようお願いします。ピル番号の調整はピルシートを作っていただいてから",
                        style: FontType.assisting.merge(TextColorStyle.main),
                      ),
                      TextSpan(
                        text: "設定 > 今日飲むピル番号の変更",
                        style:
                            FontType.assistingBold.merge(TextColorStyle.main),
                      ),
                      TextSpan(
                        text: "  へおすすみください。今日服用するピルの番号を調整できます。",
                        style: FontType.assisting.merge(TextColorStyle.main),
                      ),
                    ],
                  ),
                ),
                Text(
                  "すでに被害にあったユーザーの方々もこちらを参考にしていただけたらと思います。大型アップデート(バージョン 2.0.0) よりも前の「最後に飲んだ日」と「最後に飲んだピル番号」と「今日服用予定だったピル番号」が記載されております。現在のご自身にあった調整をよろしくお願いいたします",
                  style: FontType.assisting.merge(TextColorStyle.main),
                ),
                Text(
                  "なお現在服用している番号がすでに把握できている方はその情報をもとにアプリを使っていただいて構いません。",
                  style: FontType.assisting.merge(TextColorStyle.main),
                ),
                SizedBox(height: 10),
                Text(
                  "今回は以前からアプリを使っていただいているユーザーの方にご迷惑をおかけする形になり申し訳ありません。",
                  style: FontType.assisting.merge(TextColorStyle.main),
                ),
                Text(
                  "引き続きよろしくお願いいたします。",
                  style: FontType.assisting.merge(TextColorStyle.main),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
