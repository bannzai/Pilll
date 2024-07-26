import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/utils/local_notification.dart';

class WordTextField extends StatelessWidget {
  final Setting setting;
  final ValueNotifier<String> word;
  final TextEditingController textFieldController;
  final FocusNode focusNode;
  final SetSetting setSetting;
  final RegisterReminderLocalNotification registerReminderLocalNotification;

  const WordTextField({
    super.key,
    required this.setting,
    required this.word,
    required this.textFieldController,
    required this.focusNode,
    required this.setSetting,
    required this.registerReminderLocalNotification,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: PilllColors.secondary),
        ),
        counter: Row(children: [
          const Text(
            "通知の先頭部分の変更ができます",
            style: TextStyle(fontFamily: FontFamily.japanese, fontSize: 12, fontWeight: FontWeight.w400, color: TextColor.darkGray),
          ),
          const Spacer(),
          if (word.value.characters.isNotEmpty)
            Text(
              "${word.value.characters.length}/8",
              style: const TextStyle(fontFamily: FontFamily.japanese, fontSize: 12, fontWeight: FontWeight.w400, color: TextColor.darkGray),
            ),
          if (word.value.characters.isEmpty)
            const Text(
              "0文字以上入力してください",
              style: TextStyle(fontFamily: FontFamily.japanese, fontSize: 12, fontWeight: FontWeight.w400, color: TextColor.danger),
            ),
        ]),
      ),
      onChanged: (value) {
        word.value = value;
      },
      onSubmitted: (word) async {
        analytics.logEvent(name: "submit_rnc_word");
        try {
          await _submit(
            word: word,
            setting: setting,
            setSetting: setSetting,
            registerReminderLocalNotification: registerReminderLocalNotification,
          );
        } catch (error) {
          if (context.mounted) showErrorAlert(context, error);
        }
      },
      controller: textFieldController,
      maxLength: 8,
    );
  }

  Future<void> _submit({
    required String word,
    required Setting setting,
    required SetSetting setSetting,
    required RegisterReminderLocalNotification registerReminderLocalNotification,
  }) async {
    var reminderNotificationCustomization = setting.reminderNotificationCustomization;
    reminderNotificationCustomization = reminderNotificationCustomization.copyWith(word: word);

    setSetting(setting.copyWith(reminderNotificationCustomization: reminderNotificationCustomization));
    registerReminderLocalNotification();
  }
}
