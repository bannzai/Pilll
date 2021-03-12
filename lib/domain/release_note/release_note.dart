import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';

class ReleaseNote extends StatelessWidget {
  final VoidCallback onClose;

  const ReleaseNote({Key key, @required this.onClose}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: PilllColors.white,
      ),
      backgroundColor: PilllColors.background,
      body: Center(
        child: Container(
          width: 272,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "📣 Pilllが新しくなりました📣",
                style: FontType.sBigTitle.merge(TextColorStyle.main),
              ),
              SizedBox(height: 32),
              Text(
                "リニューアル第一弾は、①通知機能と②ピルシート機能を強化しました🐣",
                style: FontType.assistingBold.merge(TextColorStyle.main),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    border: Border.all(color: PilllColors.primary, width: 1),
                    color: PilllColors.overlay),
                constraints: BoxConstraints.loose(Size(257, 254)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "お願い🙏",
                        style:
                            FontType.assistingBold.merge(TextColorStyle.main),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "使い勝手向上のため、アプリを作り直しました。",
                        style: FontType.assisting.merge(TextColorStyle.main),
                      ),
                      SizedBox(height: 8),
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "そのため、",
                              style:
                                  FontType.assisting.merge(TextColorStyle.main),
                            ),
                            TextSpan(
                              text: "ピルシート等の再設定をおねがいします",
                              style: FontType.assistingBold
                                  .merge(TextColorStyle.main),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "ご迷惑をお掛けしますが、今後のさらなるアップデートのため、ご理解頂けると幸いです🙏😢",
                        style: FontType.assisting.merge(TextColorStyle.main),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Container(
                    width: 230,
                    child: PrimaryButton(
                        onPressed: () => onClose(), text: "お願い事項を確認した")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
