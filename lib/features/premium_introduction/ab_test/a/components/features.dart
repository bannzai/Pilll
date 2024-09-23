import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class PremiumIntroductionFeatures extends StatelessWidget {
  const PremiumIntroductionFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "プレミアム機能一覧",
          style: TextStyle(
            fontFamily: FontFamily.japanese,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: TextColor.primaryDarkBlue,
          ),
        ),
        SizedBox(height: 8),
        DefaultTextStyle(
          style: TextStyle(
            fontFamily: FontFamily.japanese,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: TextColor.main,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("📩 プッシュ通知から服用記録"),
              SizedBox(height: 4),
              Text("🗂 服用履歴の記録・閲覧"),
              SizedBox(height: 4),
              Text("📆 ピルシート上に日付表示"),
              SizedBox(height: 4),
              Text("📦 新しいピルシートを自動補充"),
              SizedBox(height: 4),
              Text("👀 過去のデータ閲覧"),
              SizedBox(height: 4),
              Text("🏷 体調タグをカスタマイズ"),
              SizedBox(height: 4),
              Text("🚫 広告の非表示"),
            ],
          ),
        ),
      ],
    );
  }
}
