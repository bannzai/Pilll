import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/root/localization/l.dart'; // Lクラスをインポート

class PillSheetModifiedHistoryCreatedPillSheetAction extends StatelessWidget {
  final DateTime date;

  const PillSheetModifiedHistoryCreatedPillSheetAction({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      L.createdPillSheet(date), // ピルシートを作成しましたを翻訳
      style: const TextStyle(
        fontFamily: FontFamily.japanese,
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: TextColor.main,
      ),
    );
  }
}
