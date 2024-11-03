import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';

class WordTextField extends StatelessWidget {
  final ValueNotifier<String> word;
  final TextEditingController textFieldController;
  final FocusNode focusNode;
  final VoidCallback submit;

  const WordTextField({
    super.key,
    required this.word,
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
        counter: Row(children: [
          const Text(
            '通知の先頭部分の変更ができます',
            style: TextStyle(
                fontFamily: FontFamily.japanese,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: TextColor.darkGray),
          ),
          const Spacer(),
          if (word.value.characters.isNotEmpty)
            Text(
              '${word.value.characters.length}/8',
              style: const TextStyle(
                  fontFamily: FontFamily.japanese,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: TextColor.darkGray),
            ),
          if (word.value.characters.isEmpty)
            const Text(
              '0文字以上入力してください',
              style: TextStyle(
                  fontFamily: FontFamily.japanese,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: TextColor.danger),
            ),
        ]),
      ),
      onChanged: (value) {
        word.value = value;
      },
      onSubmitted: (_) {
        submit();
      },
      controller: textFieldController,
      maxLength: 8,
    );
  }
}
