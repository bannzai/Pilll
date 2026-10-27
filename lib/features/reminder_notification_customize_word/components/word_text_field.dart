import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:pilll/features/localizations/l.dart';

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
          borderSide: BorderSide(color: AppColors.secondary),
        ),
        counter: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 説明文が長い言語で Row が溢れないよう、文字数の表示を除いた幅で折り返す
            Expanded(
              child: Text(
                L.changeNotificationHeader,
                style: const TextStyle(
                  fontFamily: FontFamily.japanese,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: TextColor.darkGray,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (word.value.characters.isNotEmpty)
              Text(
                '${word.value.characters.length}/8',
                style: const TextStyle(
                  fontFamily: FontFamily.japanese,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: TextColor.darkGray,
                ),
              ),
            if (word.value.characters.isEmpty)
              // 警告も言語によって長いため、説明文と幅を分け合って折り返す
              Flexible(
                child: Text(
                  L.enterAtLeastOneCharacter,
                  style: const TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: TextColor.danger,
                  ),
                ),
              ),
          ],
        ),
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
