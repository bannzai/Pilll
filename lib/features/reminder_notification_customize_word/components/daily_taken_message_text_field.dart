import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:pilll/features/error/error_alert.dart';

class DailyTakenMessageTextField extends StatelessWidget {
  final ValueNotifier<String> dailyTakenMessage;
  final TextEditingController textFieldController;
  final FocusNode focusNode;
  final VoidCallback submit;

  const DailyTakenMessageTextField({
    super.key,
    required this.dailyTakenMessage,
    required this.textFieldController,
    required this.focusNode,
    required this.submit,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      decoration: InputDecoration(
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: PilllColors.secondary),
        ),
        label: const Text(
          "通常",
          style: TextStyle(
            color: TextColor.darkGray,
            fontFamily: FontFamily.japanese,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        counter: Row(children: [
          const Text(
            "飲み忘れていない場合の通知文言を変更できます",
            style: TextStyle(fontFamily: FontFamily.japanese, fontSize: 12, fontWeight: FontWeight.w400, color: TextColor.darkGray),
          ),
          const Spacer(),
          if (dailyTakenMessage.value.characters.isNotEmpty)
            Text(
              "${dailyTakenMessage.value.characters.length}/100",
              style: const TextStyle(fontFamily: FontFamily.japanese, fontSize: 12, fontWeight: FontWeight.w400, color: TextColor.darkGray),
            ),
          if (dailyTakenMessage.value.characters.isEmpty)
            const Text(
              "0文字以上入力してください",
              style: TextStyle(fontFamily: FontFamily.japanese, fontSize: 12, fontWeight: FontWeight.w400, color: TextColor.danger),
            ),
        ]),
      ),
      onChanged: (value) {
        dailyTakenMessage.value = value;
      },
      onSubmitted: (_) {
        submit();
      },
      controller: textFieldController,
      maxLength: 100,
      maxLines: null,
    );
  }
}
