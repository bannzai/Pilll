import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/error/error_alert.dart';

class ReminderNotificationCustomizeWordPage extends HookConsumerWidget {
  final Setting setting;
  ReminderNotificationCustomizeWordPage(this.setting);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(settingStoreProvider.notifier);
    final textFieldControlelr = useTextEditingController(
        text: setting.reminderNotificationCustomization.word);
    final word = useState(setting.reminderNotificationCustomization.word);

    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "服用通知のカスタマイズ",
          style: TextStyle(color: TextColor.black),
        ),
        backgroundColor: PilllColors.background,
      ),
      body: SafeArea(
        child: Container(
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        counter: Row(children: [
                          Text(
                            "この文言とは別に今日の服用日と番号が表示されます",
                            style: TextStyle(
                                fontFamily: FontFamily.japanese,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: TextColor.darkGray),
                          ),
                          Spacer(),
                          Text(
                            "${word.value.characters.length}/20",
                            style: TextStyle(
                                fontFamily: FontFamily.japanese,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: TextColor.darkGray),
                          ),
                        ]),
                      ),
                      autofocus: true,
                      onSubmitted: (word) async {
                        try {
                          await store.reminderNotificationWordSubmit(word);
                          Navigator.of(context).pop();
                        } catch (error) {
                          showErrorAlert(context, message: error.toString());
                        }
                      },
                      controller: textFieldControlelr,
                      maxLength: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension ReminderNotificationCustomizeWordPageRoutes
    on ReminderNotificationCustomizeWordPage {
  static Route<dynamic> route({required Setting setting}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: "ReminderNotificationCustomizeWordPage"),
      builder: (_) => ReminderNotificationCustomizeWordPage(setting),
    );
  }
}
