import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/settings/setting_page_state.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:pilll/util/toolbar/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ReminderNotificationCustomizeWordPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(settingStoreProvider.notifier);
    final state = ref.watch(settingStoreProvider);
    final setting = state.setting;

    if (setting == null) {
      return Indicator();
    }

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
              _textField(context, store, setting),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField(
      BuildContext context, SettingStateStore store, Setting setting) {
    return TextField();
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
