import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/components/atoms/font.dart';
import 'package:Pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';

class ReleaseNote extends StatelessWidget {
  final VoidCallback onClose;

  const ReleaseNote({Key key, @required this.onClose}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => onClose(),
        ),
        backgroundColor: PilllColors.white,
      ),
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
                "リニューアル第一弾は、下記2点を強化しました🐣",
                style: FontType.assistingBold.merge(TextColorStyle.main),
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "通知機能",
                    style: FontType.assistingBold.merge(TextColorStyle.primary),
                  ),
                  Text(
                    '''
1. 服用済・休薬の場合は通知されない
2. バッチ表示
3. 通知文に「ピル」を入れない
                  ''',
                    style: FontType.assistingBold
                        .merge(TextColorStyle.main)
                        .merge(TextStyle(height: 1.5)),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ピルシート機能",
                    style: FontType.assistingBold.merge(TextColorStyle.primary),
                  ),
                  Text(
                    '''
4. ピルシートの破棄・追加
5. 今日飲むピル番号の変更
                  ''',
                    style: FontType.assistingBold
                        .merge(TextColorStyle.main)
                        .merge(TextStyle(height: 1.5)),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(color: PilllColors.overlay),
                constraints: BoxConstraints.loose(Size(257, 148)),
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
                              style:
                                  FontType.assisting.merge(TextColorStyle.main),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
