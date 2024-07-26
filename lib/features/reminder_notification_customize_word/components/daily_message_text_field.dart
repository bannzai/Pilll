import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/utils/local_notification.dart';

class DailyMessageTextField extends StatelessWidget {
  final Setting setting;
  final ValueNotifier<String> dailyMessage;
  final TextEditingController textFieldController;
  final SetSetting setSetting;
  final RegisterReminderLocalNotification registerReminderLocalNotification;

  const DailyMessageTextField({
    super.key,
    required this.setting,
    required this.dailyMessage,
    required this.textFieldController,
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
            "飲み忘れていない場合の通知文言を変更できます",
            style: TextStyle(fontFamily: FontFamily.japanese, fontSize: 12, fontWeight: FontWeight.w400, color: TextColor.darkGray),
          ),
          const Spacer(),
          if (dailyMessage.value.characters.isNotEmpty)
            Text(
              "${dailyMessage.value.characters.length}/8",
              style: const TextStyle(fontFamily: FontFamily.japanese, fontSize: 12, fontWeight: FontWeight.w400, color: TextColor.darkGray),
            ),
          if (dailyMessage.value.characters.isEmpty)
            const Text(
              "0文字以上入力してください",
              style: TextStyle(fontFamily: FontFamily.japanese, fontSize: 12, fontWeight: FontWeight.w400, color: TextColor.danger),
            ),
        ]),
      ),
      autofocus: true,
      onChanged: (value) {
        dailyMessage.value = value;
      },
      onSubmitted: (dailyMessage) async {
        analytics.logEvent(name: "submit_rnc_daily_message");
        try {
          await _submit(
            dailyMessage: dailyMessage,
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
    required String dailyMessage,
    required Setting setting,
    required SetSetting setSetting,
    required RegisterReminderLocalNotification registerReminderLocalNotification,
  }) async {
    var reminderNotificationCustomization = setting.reminderNotificationCustomization;
    reminderNotificationCustomization = reminderNotificationCustomization.copyWith(word: dailyMessage);

    setSetting(setting.copyWith(reminderNotificationCustomization: reminderNotificationCustomization));
    registerReminderLocalNotification();
  }
}
