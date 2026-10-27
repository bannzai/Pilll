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
        // 説明文が長い言語で Row が溢れないよう、右の表示 (文字数か警告) を除いた幅で説明文を折り返す。
        // 警告は行幅の半分までに収め、残りをすべて説明文に回す (説明文と警告を等分すると、
        // 短い警告の右に空きが残ったまま説明文が折り返す。PR #1955 の QA で ja で確認)
        counter: LayoutBuilder(
          builder: (context, constraints) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: constraints.maxWidth / 2),
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
