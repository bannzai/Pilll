import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class CounterUnitLayout extends StatelessWidget {
  final String title;
  final String number;
  final String unit;

  const CounterUnitLayout({
    super.key,
    required this.title,
    required this.number,
    required this.unit,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: TextColor.main,
            fontFamily: FontFamily.japanese,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        // 親が幅を制約した時 (Flexible 等) に数字と単位を左に寄せず、ラベルの下の中央に置くため幅を中身に合わせる
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.ideographic,
          children: [
            Text(
              number,
              style: const TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.number,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              unit,
              style: const TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
