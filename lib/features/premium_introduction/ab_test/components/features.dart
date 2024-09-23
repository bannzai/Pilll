import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class PremiumIntroductionFeatures extends StatelessWidget {
  const PremiumIntroductionFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTextStyle(
      style: TextStyle(
        fontFamily: FontFamily.japanese,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: TextColor.main,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("1. プッシュ通知から服用記録"),
          Text("2. 服用履歴の記録・閲覧"),
          Text("3. ピルシート上に日付表示"),
          Text("4. 新しいピルシートを自動補充"),
          Text("5. 過去のデータ閲覧"),
          Text("6. 体調タグをカスタマイズ"),
          Text("7. 広告の非表示"),
        ],
      ),
    );
  }
}
