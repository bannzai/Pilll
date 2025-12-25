import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:pilll/features/localizations/l.dart';

class DailyTakenMessageTextField extends StatelessWidget {
  final ValueNotifier<String> dailyTakenMessage;
  final TextEditingController textFieldController;
  final FocusNode focusNode;

  const DailyTakenMessageTextField({super.key, required this.dailyTakenMessage, required this.textFieldController, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      decoration: InputDecoration(
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.secondary)),
        label: Text(
          L.normal,
          style: const TextStyle(color: TextColor.darkGray, fontFamily: FontFamily.japanese, fontSize: 12, fontWeight: FontWeight.w400),
        ),
        counter: Row(
          children: [
            Text(
              L.changeDailyNotificationMessage,
              style: const TextStyle(fontFamily: FontFamily.japanese, fontSize: 12, fontWeight: FontWeight.w400, color: TextColor.darkGray),
            ),
            const Spacer(),
            if (dailyTakenMessage.value.characters.isNotEmpty)
              Text(
                '${dailyTakenMessage.value.characters.length}/100',
                style: const TextStyle(fontFamily: FontFamily.japanese, fontSize: 12, fontWeight: FontWeight.w400, color: TextColor.darkGray),
              ),
          ],
        ),
      ),
      onChanged: (value) {
        dailyTakenMessage.value = value;
      },
      controller: textFieldController,
      maxLength: 100,
      maxLines: null,
    );
  }
}
