import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/error/error_alert.dart';

class ReminderNotificationCustomizeWordPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(settingStoreProvider.notifier);
    final state = ref.watch(settingStoreProvider);
    final setting = state.setting;

    if (setting == null) {
      return Indicator();
    }

    final textFieldControlelr = useTextEditingController(
        text: setting.reminderNotificationCustomization.word);

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
              TextField(
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
      ),
    );
  }
}

extension ReminderNotificationCustomizeWordPageRoutes
    on ReminderNotificationCustomizeWordPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: "ReminderNotificationCustomizeWordPage"),
      builder: (_) => ReminderNotificationCustomizeWordPage(),
    );
  }
}
