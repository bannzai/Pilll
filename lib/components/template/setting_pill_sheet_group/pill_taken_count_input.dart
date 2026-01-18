import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/utils/formatter/text_input_formatter.dart';

/// 1日に何回服用するかを入力するウィジェット
/// "1日に [数字] 回服用する" の形式で表示
class PillTakenCountInput extends HookConsumerWidget {
  final ValueNotifier<int> pillTakenCount;

  const PillTakenCountInput({super.key, required this.pillTakenCount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textFieldController = useTextEditingController(text: '${pillTakenCount.value}');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '1日に',
          style: TextStyle(fontFamily: FontFamily.japanese, fontSize: 14, fontWeight: FontWeight.w400, color: TextColor.main),
        ),
        const SizedBox(width: 5),
        SizedBox(
          width: 42,
          height: 40,
          child: TextField(
            style: const TextStyle(color: TextColor.darkGray, fontSize: 15, fontFamily: FontFamily.number, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            controller: textFieldController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, AppTextFieldFormatter.greaterThanZero, _MaxValueFormatter(2)],
            decoration: const InputDecoration(
              fillColor: AppColors.mat,
              filled: true,
              border: UnderlineInputBorder(borderSide: BorderSide(width: 1)),
              contentPadding: EdgeInsets.only(bottom: 8),
            ),
            onChanged: (text) {
              final value = int.tryParse(text);
              if (value != null) {
                pillTakenCount.value = value;
              }
            },
          ),
        ),
        const SizedBox(width: 5),
        const Text(
          '回服用する',
          style: TextStyle(fontFamily: FontFamily.japanese, fontSize: 14, fontWeight: FontWeight.w400, color: TextColor.main),
        ),
      ],
    );
  }
}

/// 最大値を制限するTextInputFormatter
class _MaxValueFormatter extends TextInputFormatter {
  final int maxValue;

  _MaxValueFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    try {
      final value = int.parse(newValue.text);
      if (value > maxValue) {
        return oldValue;
      }
      return newValue;
    } catch (_) {
      return oldValue;
    }
  }
}
