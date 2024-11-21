import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/root/localization/l.dart'; // Lクラスをインポート

class PillNumber extends StatelessWidget {
  final int number;

  const PillNumber({
    super.key,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      L.pillNumber(number), // ピル番号を翻訳
      style: const TextStyle(
        fontFamily: FontFamily.japanese,
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: TextColor.main,
      ),
    );
  }
}
