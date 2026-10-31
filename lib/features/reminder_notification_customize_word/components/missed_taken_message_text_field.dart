import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:pilll/features/localizations/l.dart';

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
          borderSide: BorderSide(color: AppColors.secondary),
        ),
        label: Text(
          L.missed,
          style: const TextStyle(
            color: TextColor.darkGray,
            fontFamily: FontFamily.japanese,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        counter: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 説明文が長い言語で Row が溢れないよう、文字数の表示を除いた幅で折り返す
            Expanded(
              child: Text(
                L.changeMissedNotificationMessage,
                style: const TextStyle(
                  fontFamily: FontFamily.japanese,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: TextColor.darkGray,
                ),
              ),
            ),
            // 説明文の末尾と右の表示 (文字数・警告) の間隔。Spacer を Expanded に替えて隣接するようになったため、
            // 同じ画面の行間 (SizedBox(height: 4)) より広い 8 にして読み分けられるようにする
            const SizedBox(width: 8),
            if (missedTakenMessage.value.characters.isNotEmpty)
              Text(
                '${missedTakenMessage.value.characters.length}/100',
                style: const TextStyle(
                  fontFamily: FontFamily.japanese,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: TextColor.darkGray,
                ),
              ),
          ],
        ),
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
