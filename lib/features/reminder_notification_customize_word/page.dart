import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/features/reminder_notification_customize_word/components/daily_taken_message_text_field.dart';
import 'package:pilll/features/reminder_notification_customize_word/components/preview.dart';
import 'package:pilll/features/reminder_notification_customize_word/components/word_text_field.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/utils/local_notification.dart';

class ReminderNotificationCustomizeWordPage extends HookConsumerWidget {
  const ReminderNotificationCustomizeWordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setSetting = ref.watch(setSettingProvider);
    final setting = ref.watch(settingProvider).requireValue;

    final word = useState(setting.reminderNotificationCustomization.word);
    final dailyTakenMessage = useState(setting.reminderNotificationCustomization.dailyTakenMessage);
    final missedTakenMessage = useState(setting.reminderNotificationCustomization.missedTakenMessage);
    final wordTextFieldController = useTextEditingController(text: setting.reminderNotificationCustomization.word);
    final dailyTakenMessageTextFieldController = useTextEditingController(text: setting.reminderNotificationCustomization.dailyTakenMessage);
    final missedTakenMessageTextFieldController = useTextEditingController(text: setting.reminderNotificationCustomization.missedTakenMessage);

    final isInVisibleReminderDate = useState(setting.reminderNotificationCustomization.isInVisibleReminderDate);
    final isInVisiblePillNumber = useState(setting.reminderNotificationCustomization.isInVisiblePillNumber);
    final isInVisibleDescription = useState(setting.reminderNotificationCustomization.isInVisibleDescription);

    final registerReminderLocalNotification = ref.watch(registerReminderLocalNotificationProvider);

    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "服用通知のカスタマイズ",
          style: TextStyle(
            color: TextColor.black,
          ),
        ),
        backgroundColor: PilllColors.background,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReminderPushNotificationPreview(
                    word: word.value,
                    message: dailyTakenMessage.value,
                    isInVisibleReminderDate: isInVisibleReminderDate.value,
                    isInvisiblePillNumber: isInVisiblePillNumber.value,
                    isInvisibleDescription: isInVisibleDescription.value,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "タイトル",
                        style: TextStyle(
                          fontFamily: FontFamily.japanese,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: TextColor.primary,
                        ),
                      ),
                      WordTextField(
                        setting: setting,
                        word: word,
                        textFieldController: wordTextFieldController,
                        setSetting: setSetting,
                        registerReminderLocalNotification: registerReminderLocalNotification,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "メッセージ",
                        style: TextStyle(
                          fontFamily: FontFamily.japanese,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: TextColor.primary,
                        ),
                      ),
                      DailyTakenMessageTextField(
                        setting: setting,
                        dailyTakenMessage: dailyTakenMessage,
                        textFieldController: dailyTakenMessageTextFieldController,
                        setSetting: setSetting,
                        registerReminderLocalNotification: registerReminderLocalNotification,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "オプション",
                        style: TextStyle(
                          fontFamily: FontFamily.japanese,
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: TextColor.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _switchRow(
                        "日付を表示",
                        !isInVisibleReminderDate.value,
                        (value) async {
                          analytics.logEvent(name: "change_reminder_notification_date");
                          try {
                            await _setIsInVisibleReminderDate(
                              isInVisibleReminderDate: !value,
                              setting: setting,
                              setSetting: setSetting,
                              registerReminderLocalNotification: registerReminderLocalNotification,
                            );
                            isInVisibleReminderDate.value = !value;
                          } catch (error) {
                            if (context.mounted) showErrorAlert(context, error);
                          }
                        },
                      ),
                      const Divider(),
                      _switchRow(
                        "番号を表示",
                        !isInVisiblePillNumber.value,
                        (value) async {
                          analytics.logEvent(name: "change_reminder_notification_number");
                          try {
                            await _setIsInVisiblePillNumber(
                              isInVisiblePillNumber: !value,
                              setting: setting,
                              setSetting: setSetting,
                              registerReminderLocalNotification: registerReminderLocalNotification,
                            );
                            isInVisiblePillNumber.value = !value;
                          } catch (error) {
                            if (context.mounted) showErrorAlert(context, error);
                          }
                        },
                      ),
                      const Divider(),
                      _switchRow(
                        "説明文の表示",
                        !isInVisibleDescription.value,
                        (value) async {
                          analytics.logEvent(name: "change_reminder_notification_desc");
                          try {
                            await _setIsInVisibleDescription(
                              isInVisibleDescription: !value,
                              setting: setting,
                              setSetting: setSetting,
                              registerReminderLocalNotification: registerReminderLocalNotification,
                            );
                            isInVisibleDescription.value = !value;
                          } catch (error) {
                            if (context.mounted) showErrorAlert(context, error);
                          }
                        },
                      ),
                      const Divider(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _switchRow(String title, bool initialValue, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: TextColor.main,
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          Switch(
            value: initialValue,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Future<void> _setIsInVisibleReminderDate({
    required bool isInVisibleReminderDate,
    required Setting setting,
    required SetSetting setSetting,
    required RegisterReminderLocalNotification registerReminderLocalNotification,
  }) async {
    var reminderNotificationCustomization = setting.reminderNotificationCustomization;
    reminderNotificationCustomization = reminderNotificationCustomization.copyWith(isInVisibleReminderDate: isInVisibleReminderDate);

    setSetting(setting.copyWith(reminderNotificationCustomization: reminderNotificationCustomization));
    registerReminderLocalNotification();
  }

  Future<void> _setIsInVisiblePillNumber({
    required bool isInVisiblePillNumber,
    required Setting setting,
    required SetSetting setSetting,
    required RegisterReminderLocalNotification registerReminderLocalNotification,
  }) async {
    var reminderNotificationCustomization = setting.reminderNotificationCustomization;
    reminderNotificationCustomization = reminderNotificationCustomization.copyWith(isInVisiblePillNumber: isInVisiblePillNumber);

    setSetting(setting.copyWith(reminderNotificationCustomization: reminderNotificationCustomization));
    registerReminderLocalNotification();
  }

  Future<void> _setIsInVisibleDescription({
    required bool isInVisibleDescription,
    required Setting setting,
    required SetSetting setSetting,
    required RegisterReminderLocalNotification registerReminderLocalNotification,
  }) async {
    var reminderNotificationCustomization = setting.reminderNotificationCustomization;
    reminderNotificationCustomization = reminderNotificationCustomization.copyWith(isInVisibleDescription: isInVisibleDescription);

    await setSetting(setting.copyWith(reminderNotificationCustomization: reminderNotificationCustomization));
    await registerReminderLocalNotification();
  }
}

extension ReminderNotificationCustomizeWordPageRoutes on ReminderNotificationCustomizeWordPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: "ReminderNotificationCustomizeWordPage"),
      builder: (_) => const ReminderNotificationCustomizeWordPage(),
    );
  }
}
