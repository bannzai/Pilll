import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';

class MissedTakenMessageTextField extends StatelessWidget {
  final ValueNotifier<String> missedTakenMessage;
  final TextEditingController textFieldController;
  final FocusNode focusNode;

  const MissedTakenMessageTextField({
    super.key,
    required this.missedTakenMessage,
    required this.textFieldController,
    required this.focusNode,
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
          '飲み忘れ',
          style: TextStyle(
            color: TextColor.darkGray,
            fontFamily: FontFamily.japanese,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        counter: Row(children: [
          const Text(
            '飲み忘れてる場合の通知文言を変更できます',
            style: TextStyle(fontFamily: FontFamily.japanese, fontSize: 12, fontWeight: FontWeight.w400, color: TextColor.darkGray),
          ),
          const Spacer(),
          if (missedTakenMessage.value.characters.isNotEmpty)
            Text(
              '${missedTakenMessage.value.characters.length}/100',
              style: const TextStyle(fontFamily: FontFamily.japanese, fontSize: 12, fontWeight: FontWeight.w400, color: TextColor.darkGray),
            ),
        ]),
      ),
      onChanged: (value) {
        missedTakenMessage.value = value;
      },
      controller: textFieldController,
      maxLength: 100,
      maxLines: null,
    );
  }
}
