import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/root/localization/l.dart'; // Lクラスをインポート
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';

class PillSheetModifiedHistoryCard extends StatelessWidget {
  final PillSheetModifiedHistory history;

  const PillSheetModifiedHistoryCard({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PilllColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            L.pillSheetModifiedHistory, // ピルシート変更履歴を翻訳
            style: const TextStyle(
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: TextColor.main,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            history.summary,
            style: const TextStyle(
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: TextColor.main,
            ),
          ),
        ],
      ),
    );
  }
}
