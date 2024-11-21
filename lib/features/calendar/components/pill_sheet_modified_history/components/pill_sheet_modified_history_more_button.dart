import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/root/localization/l.dart'; // Lクラスをインポート

class PillSheetModifiedHistoryMoreButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PillSheetModifiedHistoryMoreButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        L.more, // もっと見るを翻訳
        style: const TextStyle(
          fontFamily: FontFamily.japanese,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: TextColor.main,
        ),
      ),
    );
  }
}
