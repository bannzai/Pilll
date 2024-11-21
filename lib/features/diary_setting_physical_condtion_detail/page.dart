import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/root/localization/l.dart';  // Lクラスをインポート

class DiarySettingPhysicalConditionDetailPage extends StatelessWidget {
  const DiarySettingPhysicalConditionDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        title: Text(
          L.condition,  // 体調を翻訳
          style: const TextStyle(color: TextColor.main),
        ),
        backgroundColor: PilllColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L.physicalConditionDetails,  // 体調の詳細を翻訳
              style: const TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: TextColor.main,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              L.physicalConditionDescription,  // 体調の説明を翻訳
              style: const TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: TextColor.main,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
